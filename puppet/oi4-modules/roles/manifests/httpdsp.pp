class roles::httpd {
  include profiles::base
  include profiles::httpd
  include profiles::oi4httpd_sp
}
