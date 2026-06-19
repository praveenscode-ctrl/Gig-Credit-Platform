# GigCredit — Alternative Credit Scoring for Gig Workers

> Empowering India's 300+ million gig workers with fair, transparent, and offline-capable credit scoring using alternative data and on-device AI.

---

## The Problem

Traditional credit bureaus (CIBIL, Experian) require 6+ months of formal credit history. Over **70% of India's gig workforce** — platform drivers, street vendors, daily-wage workers — are invisible to this system. They can't get loans, even when they have consistent income and responsible financial behaviour.

## Our Solution

GigCredit builds a **9-step alternative credit scoring pipeline** that evaluates a gig worker's creditworthiness using:
- Bank statement analysis
- Government scheme participation (eShram, Mudra, PM SVANidhi)
- Income regularity from platform data
- KYC identity quality
- Insurance coverage
- Tax compliance history

The score runs **completely on-device** — no sensitive data leaves the phone.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│                  Flutter Mobile App                     │
│  9-Step Data Collection → On-Device ML Scoring Engine   │
│  (m2cgen Dart models — fully offline, zero latency)     │
└────────────────────┬────────────────────────────────────┘
                     │ REST API (verified data only)
┌────────────────────▼────────────────────────────────────┐
│               FastAPI Backend (Python)                  │
│  Document Verification │ OTP Auth │ Score Storage       │
│  Loan Underwriting     │ LLM Report Generation (Groq)   │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│            MongoDB Atlas (Cloud Database)               │
│  Users │ Aadhaar/PAN Verification │ Score History       │
└─────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
GigCredit/
├── app/                        # Flutter mobile app (Dart)
│   ├── lib/
│   │   ├── features/           # UI screens by feature (auth, score, report, loans)
│   │   ├── scoring/            # On-device ML scoring engine
│   │   │   ├── models/         # m2cgen-exported Dart models (P1–P8)
│   │   │   ├── engine/         # Scoring + Confidence + Meta-Learner
│   │   │   ├── features/       # 115-feature engineering layer
│   │   │   └── explainability/ # SHAP, causal chains, XAI bundle
│   │   ├── services/           # API, OCR, session, loan services
│   │   ├── shared/             # Reusable widgets, cards, themes
│   │   └── core/               # App router, theme, providers
│   └── assets/
│       └── constants/          # Calibration knots, SHAP lookup, meta-LR coefficients
│
├── backend/                    # FastAPI Python backend
│   ├── app/
│   │   ├── api/                # Route handlers (scoring, verification, loans, OTP)
│   │   ├── services/           # Business logic (LLM, affordability, fairness engine)
│   │   ├── db/                 # MongoDB connection & seed data
│   │   ├── auth/               # Firebase OTP authentication
│   │   ├── schemas/            # Pydantic request/response models
│   │   └── utils/              # Helper utilities
│   ├── scripts/                # Database seeding scripts
│   ├── tests/                  # Backend test suite
│   ├── Dockerfile              # Container deployment config
│   ├── render.yaml             # Render.com deployment manifest
│   └── requirements.txt
│
├── ml_pipeline/                # ML training & export pipeline (Python)
│   ├── config.py               # Single source of truth — all hyperparameters & features
│   ├── generation/             # Synthetic data generator (15K profiles)
│   ├── training/               # Model training (pillars + meta-learner + calibration)
│   ├── export/                 # m2cgen Dart export + golden test generator
│   ├── loan/                   # Loan decision model (LightGBM classifier)
│   ├── explainability/         # SHAP extraction + attention proxy
│   └── output/
│       ├── models/             # Trained .pkl model files
│       └── assets/             # JSON configs (calibration, SHAP, meta-LR)
│
└── contracts/                  # API & data contracts between frontend/backend
```

---

## The 8-Pillar Scoring Model

| Pillar | Name | Algorithm | Weight |
|:---:|:---|:---|:---:|
| P1 | Income Reliability | LightGBM GBDT | 22% |
| P2 | Spending Discipline | XGBoost GBDT | 18% |
| P3 | Debt Servicing | XGBoost (Shallow) | 12% |
| P4 | Savings Behavior | LightGBM GBDT | 13% |
| P5 | KYC Identity Quality | Weighted Scorecard | 10% |
| P6 | Insurance Protection | ExtraTrees Ensemble | 10% |
| P7 | Social & Welfare Support | Weighted Scorecard | 8% |
| P8 | Tax Compliance Status | Weighted Scorecard | 7% |

**Meta-Learner:** Logistic Regression (20 inputs → single probability → score 300–900)  
**Calibration:** Isotonic Regression + Conformal Prediction intervals per work type

---

## On-Device ML Architecture (Key Innovation)

All 5 ML models (P1, P2, P3, P4, P6) are **transpiled from Python `.pkl` to native Dart** using [`m2cgen`](https://github.com/BayesWitnesses/m2cgen). This means:

- ✅ **Zero network calls** for scoring — runs 100% offline
- ✅ **Zero latency** — no server round-trip
- ✅ **Privacy-preserving** — financial data never leaves the device
- ✅ **Mathematical parity** — identical outputs to the Python backend (verified by `golden_100.json` test suite)

---

## Tech Stack

| Layer | Technology |
|:---|:---|
| Mobile App | Flutter (Dart), Firebase Auth |
| Backend API | FastAPI (Python 3.11), Uvicorn |
| Database | MongoDB Atlas (Motor async driver) |
| ML Training | LightGBM, XGBoost, scikit-learn, SHAP |
| Model Export | m2cgen (Python → Dart transpiler) |
| LLM Explanation | Groq API (llama-3.3-70b-versatile) |
| OCR | Google ML Kit (on-device), Gemini Vision |
| Deployment | Render.com (Docker), MongoDB Atlas |

---

## ML Pipeline — How to Retrain

```bash
cd ml_pipeline

# 1. Generate synthetic training data (15,000 profiles)
python -m generation.synthetic_data_generator

# 2. Train all 5 pillar ML models
python -m training.train_pillars_v3

# 3. Run isotonic calibration + conformal prediction
python -m training.calibration

# 4. Train meta-learner (Logistic Regression fusion)
python -m training.meta_learner_v3

# 5. Export models to Dart via m2cgen
python -m export.export_m2cgen_v3

# 6. Generate golden test profiles
python -m export.golden_test_v3

# 7. Extract SHAP explanations
python -m explainability.shap_extractor

# 8. Train loan decision model
python -m loan.loan_lgbm_trainer
```

---

## Backend Setup

```bash
cd backend

# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Fill in: MONGODB_URI, GROQ_API_KEY, FIREBASE credentials

# Seed the database
python scripts/seed_db.py

# Run development server
uvicorn app.main:app --reload --port 8000
```

---

## Flutter App Setup

```bash
cd app

# Install Flutter dependencies
flutter pub get

# Run on connected device
flutter run
```

> The app points to the deployed Render.com backend by default. To use a local backend, update `lib/services/real_api_service.dart` base URL.

---

## Score Output

| Score | Grade | Risk Band |
|:---:|:---:|:---:|
| 800–900 | A+ | Very Low Risk |
| 750–799 | A | Very Low Risk |
| 700–749 | B+ | Low Risk |
| 650–699 | B | Low Risk |
| 600–649 | C+ | Medium Risk |
| 550–599 | C | Medium Risk |
| 300–549 | D | High Risk |

---

## Project

GigCredit is an open-source alternative credit scoring platform built for India's informal gig workforce.
