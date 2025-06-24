#!/bin/sh

python3 tests/unit_tests.py ${@}
python3 tests/test_api.py ${@}
python3 tests/test_capper_tracker.py ${@}