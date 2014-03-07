require 'ar_inception/version'
require 'active_record'
require 'active_support/core_ext/module'
require 'thread'

module ArInception
  MAX_ESCAPE_DEPTH = 10

  def self.install
    return if ActiveRecord::Base.respond_to?(:escape_transaction)

    #
    # These changes are only used for the non-threaded implementation
    # 
    ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do

      #
      # for every nested escape, this is incremented to ensure a
      # fresh connection. This must be a thread-local because the suffix
      # is relative to the base per-thread connection. in other words,
      # the connection_id is a compound key of (thread_id, escape_level)
      #
      Thread.current["_connection_id_suffix"] = 0

      #
      # Increases/decreases "escape count" by the specified amount, usually +/- 1
      # Returns new escape count.
      #
      # May throw an exception if we've escaped too deep or the escape level has
      # been corrupted somehow
      #
      def adjust_escape_suffix(val)
        res = (Thread.current["_connection_id_suffix"] || 0) + val
        raise "Decrementing escape suffix below 0"    if res < 0
        raise "Decrementing escape suffix above 10"   if res > ArInception::MAX_ESCAPE_DEPTH
        Thread.current["_connection_id_suffix"] = res
      end

      private
      
      #
      # ConnectionPool uses 'current_connection_id' as a key into a collection of connections.
      # each thread is intended to have its own 
      #
      def current_connection_id_with_escape
        base   = current_connection_id_without_escape
        suffix = Thread.current["_connection_id_suffix"] || 0
        suffix == 0 ? base : "#{base}-#{suffix}"
      end
      
      alias_method_chain :current_connection_id, :escape
    end
    
    class << ActiveRecord::Base
      #
      # Evaluate the block outside any current ActiveRecord transactional context;
      # i.e., every DB interaction will be done with a connection that has no
      # open transactions.  This may be the current per-Thread connection or 
      # a freshly allocated one.
      #
      # The primary use for this is to commit an update to the database that
      # will survive a rollback in any currently open transaction.
      #
      # This method may block or raise an exception if the connection pool is
      # exhausted.
      #
      #
      # This implementation does not create new threads, but rather uses a different connection in
      # the current thread for the duration of the 'escape_transaction' dynamic scope.
      # 
      # The advantage of this approach is that any code which depends on thread-locals
      # will still be available
      #
      def escape_transaction
        if connection.open_transactions == 0
          yield
        else
          conn       = nil
          adjusted   = nil
          begin
            adjusted = connection_pool.adjust_escape_suffix(1)
            conn     = connection
            yield
          ensure
            # return the connection to the pool and 
            ActiveRecord::Base.connection_pool.checkin(conn) if conn
            connection_pool.adjust_escape_suffix(-1)         if adjusted
          end
        end
      end

      #
      # Evaluate the block outside any current ActiveRecord transactional context;
      # i.e., every DB interaction will be done with a connection that has no
      # open transactions.  As this implementation evaluates the block in a 
      # new thread, it will definitely use a different connection from the one
      # 'current' in the calling code, and any thread-locals accessed in the
      # dynamic scope will be different (or absent) during the block's evaluation.
      #
      # The primary use for this is to commit an update to the database that
      # will survive a rollback in any currently open transaction.
      #
      # This method may block or raise an exception if the connection pool is
      # exhausted.
      #
      def escape_transaction_via_thread
        Thread.new do
          begin
            yield
          ensure
            # return this thread's connection to the pool
            ActiveRecord::Base.clear_active_connections!
          end
        end.join
      end
    end
    
  end
end

ArInception.install
