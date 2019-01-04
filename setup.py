#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from setuptools import Extension
from setuptools import setup


extra_compile_args = []  # ("-lm", "-lrt", "-s", "-ldl")
extra_link_args = ("-flto", "-ffast-math", "-march=native", "-O3")  # ("-c", "-w", "-flto", "-ffast-math", "-march=native", "-O3", "-fno-strict-aliasing", "-fPIC")
sources = """nimbase.h
stdlib_asyncstreams.c
stdlib_httpcore.c
stdlib_os.c
stdlib_strscans.c
stdlib_base64.c
stdlib_json.c
stdlib_ospaths.c
stdlib_strtabs.c
nimpy_nimpy.c
stdlib_bitops.c
stdlib_lexbase.c
stdlib_parsejson.c
stdlib_strutils.c
nimpy_py_lib.c
stdlib_complex.c
stdlib_lists.c
stdlib_parseutils.c
stdlib_system.c
nimpy_py_types.c
stdlib_cstrutils.c
stdlib_macros.c
stdlib_posix.c
stdlib_tables.c
nimpy_py_utils.c
stdlib_deques.c
stdlib_math.c
stdlib_random.c
stdlib_times.c
stdlib_algorithm.c
stdlib_dynlib.c
stdlib_mimetypes.c
stdlib_selectors.c
stdlib_typetraits.c
stdlib_asyncdispatch.c
stdlib_epoll.c
stdlib_nativesockets.c
stdlib_sequtils.c
stdlib_unicode.c
stdlib_asyncfile.c
stdlib_hashes.c
stdlib_net.c
stdlib_sets.c
stdlib_uri.c
stdlib_asyncfutures.c
stdlib_heapqueue.c
stdlib_openssl.c
stdlib_streams.c
stdlib_asyncnet.c
stdlib_httpclient.c
stdlib_options.c
stdlib_strformat.c
faster_than_requests_faster_than_requests.c
""".splitlines()


setup(
    ext_modules = [
        Extension(
            name               = "faster_than_requests",
            sources            = sources,
            extra_compile_args = extra_compile_args,
            extra_link_args    = extra_link_args,
        )
    ]
)
