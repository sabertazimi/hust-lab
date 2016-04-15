long int long_tmin() {
  return
    /* $begin long_tmin_solve */
    /* Shift 1 over by 8*sizeof(long) - 1 */
    1L  << (sizeof(long)<<3) - 1
    /* $end long_tmin_solve */
    ;
}
