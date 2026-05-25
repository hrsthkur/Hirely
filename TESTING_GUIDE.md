# 🧪 Testing Guide - Hirely Project

## Overview
This document provides complete testing instructions following industry best practices with priority-based approach.

---

## 📁 Backend Testing Setup

### Test Structure
```
backend/HirelyBackend/
├── pytest.ini                    # Pytest configuration
├── .coveragerc                   # Coverage configuration
├── conftest.py                   # Shared fixtures
├── requirements-test.txt         # Test dependencies
├── run_tests.sh                  # Linux/Mac test runner
├── run_tests.ps1                 # Windows test runner
│
├── users/tests/
│   ├── __init__.py
│   └── test_authentication.py    # 🔴 CRITICAL - Auth tests
│
└── applications/tests/
    ├── __init__.py
    ├── test_resume_scoring.py    # 🔴 CRITICAL - Resume scoring
    └── test_jobs_applications.py # 🟡 HIGH - Job & app tests
```

---

## 🚀 Quick Start - Running Tests

### 1. Install Test Dependencies
```bash
cd backend/HirelyBackend
pip install -r requirements-test.txt
```

### 2. Run All Tests
```bash
# Linux/Mac
./run_tests.sh

# Windows PowerShell
.\run_tests.ps1

# Or directly with pytest
pytest -v
```

### 3. Run Specific Test Files
```bash
# Run only authentication tests
pytest users/tests/test_authentication.py -v

# Run only resume scoring tests
pytest applications/tests/test_resume_scoring.py -v

# Run only job/application tests
pytest applications/tests/test_jobs_applications.py -v
```

### 4. Run Tests with Coverage
```bash
# Generate coverage report
pytest --cov --cov-report=html --cov-report=term-missing

# View HTML report
# Open htmlcov/index.html in browser
```

### 5. Run Specific Test Classes or Methods
```bash
# Run specific class
pytest users/tests/test_authentication.py::TestUserLogin -v

# Run specific test
pytest users/tests/test_authentication.py::TestUserLogin::test_login_success_with_username -v
```

---

## 📊 Test Coverage Goals

| **Module** | **Target Coverage** | **Priority** |
|------------|---------------------|--------------|
| Authentication | 90%+ | 🔴 Critical |
| Resume Scoring | 85%+ | 🔴 Critical |
| Job CRUD | 80%+ | 🟡 High |
| Applications | 80%+ | 🟡 High |
| Overall | 75%+ | Target |

---

## 🧪 Test Categories

### 🔴 Critical Priority Tests (Implemented)

#### 1. Authentication Tests (`users/tests/test_authentication.py`)
- ✅ User registration (candidate & employer)
- ✅ Duplicate username/email prevention
- ✅ Password validation
- ✅ User login (username & email)
- ✅ JWT token generation & validation
- ✅ Protected endpoint access
- ✅ Token refresh mechanism
- ✅ Role-based permissions
- ✅ User model functionality

**Run:** `pytest users/tests/test_authentication.py -v`

#### 2. Resume Scoring Tests (`applications/tests/test_resume_scoring.py`)
- ✅ Score calculation (0-5 range)
- ✅ Perfect match scoring
- ✅ No match scoring
- ✅ Empty input handling
- ✅ Score consistency
- ✅ Skills bonus application
- ✅ Skill matching bonus
- ✅ Score capping at 5.0
- ✅ Email/phone extraction
- ✅ Skills extraction
- ✅ Education/experience extraction
- ✅ PDF/TXT file parsing
- ✅ Error handling
- ✅ Complete integration flow

**Run:** `pytest applications/tests/test_resume_scoring.py -v`

### 🟡 High Priority Tests (Implemented)

#### 3. Job & Application Tests (`applications/tests/test_jobs_applications.py`)
- ✅ Job CRUD operations
- ✅ Job creation validation
- ✅ Permission checks (own vs others' jobs)
- ✅ Job listing & filtering
- ✅ Application submission
- ✅ Duplicate application prevention
- ✅ View applications
- ✅ Status management
- ✅ Job search & filtering
- ✅ Model relationships

**Run:** `pytest applications/tests/test_jobs_applications.py -v`

---

## 🎯 Test Fixtures Available

All fixtures are defined in `conftest.py`:

```python
# Client fixtures
api_client              # Unauthenticated API client
authenticated_client    # Authenticated employer client

# User fixtures
employer_user          # Employer user instance
candidate_user         # Candidate user instance

# Data fixtures
sample_job             # Single job instance
sample_application     # Single application instance
multiple_jobs          # List of 3 jobs
```

### Using Fixtures in Tests
```python
@pytest.mark.django_db
def test_example(api_client, employer_user, sample_job):
    # Your test code here
    pass
```

---

## 📝 Writing New Tests

### Test Naming Convention
```python
# Test files: test_*.py
# Test classes: Test<FeatureName>
# Test methods: test_<action>_<expected_result>

# ✅ Good examples
test_authentication.py
class TestUserLogin:
    def test_login_success_with_valid_credentials(self):
        pass

# ❌ Bad examples
auth_tests.py
class LoginTests:
    def check_login(self):
        pass
```

### Test Structure Template
```python
import pytest
from rest_framework import status

@pytest.mark.django_db
class TestFeatureName:
    """Test description"""
    
    def test_successful_case(self, api_client):
        """Test successful scenario"""
        # Arrange
        data = {'key': 'value'}
        
        # Act
        response = api_client.post('/api/endpoint/', data)
        
        # Assert
        assert response.status_code == status.HTTP_200_OK
        assert 'expected_key' in response.data
    
    def test_failure_case(self, api_client):
        """Test failure scenario"""
        # Arrange
        invalid_data = {}
        
        # Act
        response = api_client.post('/api/endpoint/', invalid_data)
        
        # Assert
        assert response.status_code == status.HTTP_400_BAD_REQUEST
```

---

## 🐛 Debugging Failed Tests

### 1. Run with Verbose Output
```bash
pytest -vv --tb=long
```

### 2. Run with Print Statements
```bash
pytest -s
```

### 3. Run Single Test for Debugging
```bash
pytest path/to/test.py::TestClass::test_method -vv -s
```

### 4. Use pytest Debugging
```bash
pytest --pdb  # Drop into debugger on failure
```

---

## 📈 Continuous Integration

### GitHub Actions Workflow (To be implemented)
```yaml
name: Backend Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      - name: Install dependencies
        run: |
          cd backend/HirelyBackend
          pip install -r requirements.txt
          pip install -r requirements-test.txt
      - name: Run tests
        run: |
          cd backend/HirelyBackend
          pytest --cov --cov-report=xml
      - name: Upload coverage
        uses: codecov/codecov-action@v3
```

---

## 🔄 Test-Driven Development (TDD) Workflow

1. **Write Test First** (Red)
   ```python
   def test_new_feature(self):
       result = new_function()
       assert result == expected_value
   ```

2. **Run Test** (Should fail)
   ```bash
   pytest path/to/test.py -v
   ```

3. **Implement Feature** (Green)
   ```python
   def new_function():
       return expected_value
   ```

4. **Run Test Again** (Should pass)
   ```bash
   pytest path/to/test.py -v
   ```

5. **Refactor** (Keep it green)

---

## 📋 Test Checklist Before Commit

- [ ] All tests pass locally
- [ ] New features have tests
- [ ] Bug fixes have regression tests
- [ ] Coverage is maintained or improved
- [ ] No print/debug statements left
- [ ] Test names are descriptive
- [ ] Tests are independent (no order dependency)

---

## 🎓 Best Practices

### 1. Keep Tests Independent
```python
# ✅ Good - Each test is independent
def test_create_user(self):
    user = User.objects.create(username='test')
    assert user.username == 'test'

def test_delete_user(self):
    user = User.objects.create(username='test2')
    user.delete()
    assert not User.objects.filter(username='test2').exists()

# ❌ Bad - Tests depend on each other
def test_create_user(self):
    self.user = User.objects.create(username='test')

def test_delete_user(self):
    self.user.delete()  # Depends on previous test
```

### 2. Use Descriptive Names
```python
# ✅ Good
def test_cannot_apply_twice_for_same_job(self):
    pass

# ❌ Bad
def test_application(self):
    pass
```

### 3. One Assertion Per Concept
```python
# ✅ Good
def test_user_creation_sets_username(self):
    user = User.objects.create(username='test')
    assert user.username == 'test'

def test_user_creation_sets_email(self):
    user = User.objects.create(username='test', email='test@example.com')
    assert user.email == 'test@example.com'

# ⚠️ Acceptable (related assertions)
def test_user_creation(self):
    user = User.objects.create(username='test', email='test@example.com')
    assert user.username == 'test'
    assert user.email == 'test@example.com'
```

### 4. Use Fixtures for Common Setup
```python
# ✅ Good - Use fixture
@pytest.fixture
def authenticated_user(api_client, employer_user):
    api_client.force_authenticate(user=employer_user)
    return api_client

def test_with_auth(authenticated_user):
    response = authenticated_user.get('/api/endpoint/')
    assert response.status_code == 200

# ❌ Bad - Repeat setup
def test_with_auth(self):
    user = User.objects.create(...)
    client = APIClient()
    client.force_authenticate(user=user)
    # ... test code
```

---

## 📊 Current Test Statistics

```bash
# Run to get statistics
pytest --co -q  # Count tests
pytest --cov --cov-report=term-missing  # Coverage report
```

**As of implementation:**
- ✅ 40+ tests implemented
- ✅ 3 critical test modules
- ✅ Authentication: 15 tests
- ✅ Resume Scoring: 20+ tests
- ✅ Jobs & Applications: 15+ tests

---

## 🚦 Next Steps

### Phase 2 - Frontend Testing (Upcoming)
- [ ] Setup Vitest & React Testing Library
- [ ] Component unit tests
- [ ] Integration tests
- [ ] E2E tests with Playwright

### Phase 3 - Advanced Testing
- [ ] Performance testing
- [ ] Security testing
- [ ] Load testing
- [ ] API contract testing

---

## 📞 Troubleshooting

### Issue: "pytest: command not found"
```bash
pip install pytest pytest-django
```

### Issue: "No module named pytest_django"
```bash
pip install pytest-django
```

### Issue: Tests fail with database errors
```bash
# Ensure test database exists
python manage.py migrate --settings=HirelyBackend.settings
```

### Issue: Import errors
```bash
# Ensure you're in the correct directory
cd backend/HirelyBackend
pytest
```

---

**Happy Testing! 🎉**

*Last Updated: November 24, 2025*
