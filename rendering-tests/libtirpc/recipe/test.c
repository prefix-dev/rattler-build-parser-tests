// https://github.com/Homebrew/homebrew-core/blob/f99472a12a14f7512309ebedd2fd44072737ac34/Formula/lib/libtirpc.rb#L29-L40
// BSD 2-Clause License
// Copyright (c) 2009-present, Homebrew contributors
// All rights reserved.
#include <rpc/rpc.h>
#include <rpc/xdr.h>
#include <stdio.h>

int main() {
  XDR xdr;
  char buf[256];
  xdrmem_create(&xdr, buf, sizeof(buf), XDR_ENCODE);
  int i = 42;
  xdr_destroy(&xdr);
  printf("xdr_int succeeded");
  return 0;
}
