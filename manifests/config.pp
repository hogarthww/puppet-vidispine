# see README.md
class vidispine::config {

  Set {
    ensure       => present,
    dashost      => $vidispine::glassfish_das_host,
    portbase     => $vidispine::glassfish_das_portbase,
    asadminuser  => $vidispine::glassfish_asadmin_user,
    passwordfile => $vidispine::glassfish_asadmin_passfile,
    user         => $vidispine::glassfish_user,
  }

  # set server http thread pool size if we are running standalone vidispine
  set { 'server-config.thread-pools.thread-pool.http-thread-pool.max-thread-pool-size':
    value => $vidispine::vidispine_http_pool_size,
  }

  # set server http thread pool timeout if we are running standalone vidispine
  set { 'server-config.thread-pools.thread-pool.http-thread-pool.idle-thread-timeout-seconds':
    value => $vidispine::vidispine_http_pool_timeout,
  }

  # set server noauth thread pool size if we are running standalone vidispine
  set { 'server-config.thread-pools.thread-pool.noauth-pool.max-thread-pool-size':
    value => $vidispine::vidispine_noauth_pool_size,
  }

  # set server noauth thread pool idle timeout if we are running standalone vidispine
  set { 'server-config.thread-pools.thread-pool.noauth-pool.idle-thread-timeout-seconds':
    value => $vidispine::vidispine_noauth_pool_timeout,
  }

  # set server solr thread pool size if we are running standalone vidispine
  set { 'server-config.thread-pools.thread-pool.solr-pool.max-thread-pool-size':
    value => $vidispine::vidispine_solr_pool_size,
  }

  # set vidispine jdbc pool max size if we running the glassfish das
  if ($vidispine::vidispine_jdbc_max_size) {
    set { 'resources.jdbc-connection-pool.VidispinePool.max-pool-size':
      value => $vidispine::vidispine_jdbc_max_size,
    }
  }

  # How long the JDBC connection pool manager should make a thread wait for an available slot
  if ($vidispine::vidispine_jdbc_max_wait_time) {
    set { 'resources.jdbc-connection-pool.VidispinePool.max-wait-time-in-millis':
      value => $vidispine::vidispine_jdbc_max_wait_time,
    }
  }

}
