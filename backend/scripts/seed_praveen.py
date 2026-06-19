#!/usr/bin/env python3
"""
Seed Praveen Kumar P's EXACT verification data into MongoDB.
All values extracted directly via PaddleOCR + pdfplumber from real documents.

Aadhaar front OCR lines:
  'Government of India'
  'Aadhaar no.issued:18/11/2015'
  'Praveen Kumar P'          ← name
  '/DB09/01/2007'            ← DOB
  'f/Male'
  '74942006 7990' / '7494 2006 7990'  ← number

Aadhaar back OCR lines:
  'Address:S/O:Prabhakaran,205F,SRIRANGAM NEW'
  'TOWN, WIMCO NAGAR, SAKTHIPURAM,Kattivakkam'
  'PO:Ennore Thermal Station, DIST:Tiruvallur, Tamil Nadu,'
  '600057'
  '749420067990'             ← full number confirmed

PAN OCR lines:
  't r/Date of Birth'
  'INCOME TAX DEPARTMENT'
  'TA/Name'
  '09/01/2007'               ← DOB
  'PRABAKARAN'               ← father's name
  'TT/Fathers Name'
  'PRAVEEN KUMAR P'          ← name (line 6)
  'Permanent Account Number Card'
  'IPZPP3254R'               ← PAN number

Bank Statement (pdfplumber):
  Name:    PRAVEEN KUMAR P
  Account: 924010058793901
  IFSC:    UTIB0000345
  MICR:    600211013
  PAN:     IPZPP3254R
  Mobile:  XXXXXX9092
  Bank:    Axis Bank
  Branch:  Mogappair East (UTIB0000345)
"""
import asyncio
import certifi
from motor.motor_asyncio import AsyncIOMotorClient

MONGODB_URI = "mongodb+srv://hackathonproject789_db_user:praveen@cluster0.c4lcly9.mongodb.net/?appName=Cluster0"
DB_NAME = "gigcredit"

# ── Exact data from OCR ───────────────────────────────────────────────────────
AADHAAR = {
    "aadhaar": "749420067990",
    "name": "Praveen Kumar P",
    "dob": "09/01/2007",          # as on card: DD/MM/YYYY
    "dob_iso": "2007-01-09",
    "gender": "Male",
    "address": "S/O: Prabhakaran, 205F, Srirangam New Town, Wimco Nagar, Sakthipuram, Kattivakkam, PO: Ennore Thermal Station, DIST: Tiruvallur, Tamil Nadu - 600057",
    "state": "Tamil Nadu",
    "pincode": "600057",
    "issued_date": "18/11/2015",
    "status": "active",
}

PAN = {
    "pan": "IPZPP3254R",
    "name": "Praveen Kumar P",
    "fathers_name": "Prabakaran",
    "dob": "09/01/2007",
    "dob_iso": "2007-01-09",
    "pan_active": True,
    "itr_filed": False,
    "itr_years": [],
}

IFSC = {
    "ifsc": "UTIB0000345",
    "bank_name": "Axis Bank",
    "branch_name": "Mogappair East",
    "city": "Chennai",
    "state": "Tamil Nadu",
    "micr": "600211013",
}

BANK_ACCOUNT = {
    "account_number": "924010058793901",
    "ifsc": "UTIB0000345",
    "account_holder": "Praveen Kumar P",
    "account_type": "Savings",
    "account_active": True,
    "bank_name": "Axis Bank",
    "branch_name": "Mogappair East",
    "micr": "600211013",
    "customer_id": "970069607",
    "mobile": "9500009092",
    "email": "prxxxx07@gmail.com",
    "pan": "IPZPP3254R",
    "scheme": "SB-Priority Banking",
    "statement_period": "19-09-2025 to 19-03-2026",
}


async def seed():
    print("Connecting to MongoDB Atlas...")
    client = AsyncIOMotorClient(MONGODB_URI, tlsCAFile=certifi.where())
    db = client[DB_NAME]

    r = await db.aadhaar_db.update_one({"aadhaar": AADHAAR["aadhaar"]}, {"$set": AADHAAR}, upsert=True)
    print(f"[Aadhaar]  {'inserted' if r.upserted_id else 'updated'}: {AADHAAR['aadhaar']} → {AADHAAR['name']}")

    r = await db.pan_db.update_one({"pan": PAN["pan"]}, {"$set": PAN}, upsert=True)
    print(f"[PAN]      {'inserted' if r.upserted_id else 'updated'}: {PAN['pan']} → {PAN['name']}")

    r = await db.ifsc_db.update_one({"ifsc": IFSC["ifsc"]}, {"$set": IFSC}, upsert=True)
    print(f"[IFSC]     {'inserted' if r.upserted_id else 'updated'}: {IFSC['ifsc']} → {IFSC['bank_name']}, {IFSC['branch_name']}")

    r = await db.bank_accounts_db.update_one(
        {"account_number": BANK_ACCOUNT["account_number"], "ifsc": BANK_ACCOUNT["ifsc"]},
        {"$set": BANK_ACCOUNT}, upsert=True
    )
    print(f"[Bank]     {'inserted' if r.upserted_id else 'updated'}: {BANK_ACCOUNT['account_number']} → {BANK_ACCOUNT['account_holder']}")

    # ── Verify ────────────────────────────────────────────────────────────────
    print("\n── Verification ──────────────────────────────────────────────────")
    a = await db.aadhaar_db.find_one({"aadhaar": "749420067990"})
    p = await db.pan_db.find_one({"pan": "IPZPP3254R"})
    i = await db.ifsc_db.find_one({"ifsc": "UTIB0000345"})
    b = await db.bank_accounts_db.find_one({"account_number": "924010058793901"})

    print(f"Aadhaar:  {a['name'] if a else 'NOT FOUND'} | DOB: {a['dob'] if a else '-'}")
    print(f"PAN:      {p['name'] if p else 'NOT FOUND'} | DOB: {p['dob'] if p else '-'}")
    print(f"IFSC:     {i['bank_name'] + ' - ' + i['branch_name'] if i else 'NOT FOUND'}")
    print(f"Bank:     {b['account_holder'] if b else 'NOT FOUND'} | Active: {b.get('account_active') if b else '-'}")

    # ── Wrong number test ─────────────────────────────────────────────────────
    print("\n── Wrong number test ─────────────────────────────────────────────")
    wrong_aadhaar = await db.aadhaar_db.find_one({"aadhaar": "749420067991"})  # last digit wrong
    wrong_pan     = await db.pan_db.find_one({"pan": "IPZPP3254S"})            # last letter wrong
    print(f"Aadhaar 749420067991 (wrong): {'FOUND (BUG!)' if wrong_aadhaar else 'NOT FOUND (correct - 404)'}")
    print(f"PAN IPZPP3254S (wrong):       {'FOUND (BUG!)' if wrong_pan else 'NOT FOUND (correct - 404)'}")

    print("\nSeed complete!")
    client.close()


if __name__ == "__main__":
    asyncio.run(seed())
