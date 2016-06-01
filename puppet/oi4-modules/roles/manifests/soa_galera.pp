class roles::soa_galera {
  include profiles::base
  include profiles::bas
  include profiles::soa
  include profiles::lb_galera
}
