from m365toolkit.security.score_calculator import calculate_security_score

def test_score_floor():
    assert calculate_security_score(999,999,999,999) == 10

def test_score_clean():
    assert calculate_security_score() == 100
