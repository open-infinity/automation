class roles::basssogalera {
  include profiles::base
  include profiles::bas
  include profiles::httpd
  include profiles::httpd_sp
  include profiles::lb_galera
}
