from m365toolkit.utils.retry import retry

def test_retry_success():
    assert retry(lambda: 1) == 1
