() {

  local opts=(
    no_unset
    rc_quotes
    mark_dirs
    re_match_pcre
    chase_links
    glob_star_short
    extended_glob
    csh_null_glob
    globdots
    no_case_glob
    no_glob_subst
  )

  setopt $^opts

}
