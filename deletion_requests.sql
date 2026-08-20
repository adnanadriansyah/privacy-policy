-- ============================================
-- Tabel: deletion_requests
-- Untuk menyimpan permintaan penghapusan akun
-- dari aplikasi Suara Digital Desa
-- ============================================

CREATE TABLE IF NOT EXISTS deletion_requests (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email         TEXT NOT NULL,
  full_name     TEXT NOT NULL,
  reason        TEXT NOT NULL,
  message       TEXT,
  status        TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'rejected')),
  requested_at  TIMESTAMPTZ DEFAULT NOW(),
  processed_at  TIMESTAMPTZ,
  notes         TEXT
);

-- Aktifkan Row Level Security
ALTER TABLE deletion_requests ENABLE ROW LEVEL SECURITY;

-- Policy: anon bisa INSERT (kirim permintaan)
CREATE POLICY "allow_anonymous_insert"
  ON deletion_requests
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Policy: hanya service_role yang bisa SELECT / UPDATE
CREATE POLICY "service_role_full_access"
  ON deletion_requests
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Index untuk pencarian berdasarkan email
CREATE INDEX idx_deletion_requests_email ON deletion_requests (email);

-- Index untuk filter berdasarkan status
CREATE INDEX idx_deletion_requests_status ON deletion_requests (status);

-- Komentar pada tabel
COMMENT ON TABLE deletion_requests IS 'Menyimpan permintaan penghapusan akun dari pengguna Suara Digital Desa';
COMMENT ON COLUMN deletion_requests.status IS 'Status: pending, processing, completed, rejected';
