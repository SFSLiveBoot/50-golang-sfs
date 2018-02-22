# add /usr/local/go/bin to the path if needed

which go >/dev/null || 
  test ! -x /usr/local/go/bin/go || 
  case ":$PATH:" in
    *:/usr/local/go/bin:*) ;;
    *) PATH="$PATH:/usr/local/go/bin";;
  esac
