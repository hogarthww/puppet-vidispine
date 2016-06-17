## 2016-01-26 - Version 3.0.0

This is a new major release and includes non-backwards-compatible changes.

This release includes:
 * Divestment of responsibilities. The following things are no longer managed by this module,
 responsibility being deferred to your profile module:
   * Apt repositories
   * Installation of Java (with the addition of the mandatory `java_home` parameter)
   * New Relic agent
 * Some parameters have been removed, some have been added, some have been made
   mandatory where they were previously optional.
 * Licenses are now managed in a different way dedicated resource types. License validation via the
 Vidispine API is also supported, meaning that Puppet can wait for license validation to complete
 before proceeding with configuring the application.
 * Code has undergone major refactor and cleanup
 * Custom type names are now consistent and always begin with `vidispine_`
 * Clustering support has been dropped. As it was left unused while many substantial changes
 happened in 2.x, it was almost certainly not working. Cluster support may return with support of
 newer Vidispine versions.
 * Improved test coverage, misc bugfixes and other enhancements.

