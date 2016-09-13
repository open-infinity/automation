class roles::baswflb {
  include profiles::base
  include profiles::httpd_sp
  include profiles::haproxy
  include profiles::keepalived
}
