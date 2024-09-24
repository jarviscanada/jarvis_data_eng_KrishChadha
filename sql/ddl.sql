-- Switch to the host_agent database
\c host_agent;

-- Create the host_info table
CREATE TABLE IF NOT EXISTS PUBLIC.host_info (
  id SERIAL PRIMARY KEY,
  hostname VARCHAR NOT NULL UNIQUE,
  cpu_number INT2 NOT NULL,
  cpu_architecture VARCHAR NOT NULL,
  cpu_model VARCHAR NOT NULL,
  cpu_mhz FLOAT8 NOT NULL,
  l2_cache INT4 NOT NULL,
  "timestamp" TIMESTAMP NOT NULL,
  total_mem INT4 NOT NULL
);

-- Insert sample data into host_info table
INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem) 
VALUES 
('jrvs-remote-desktop-centos7-6.us-central1-a.c.spry-framework-236416.internal', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324),
('noe1', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324),
('noe2', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324)
ON CONFLICT (hostname) DO NOTHING;

-- Create the host_usage table
CREATE TABLE IF NOT EXISTS PUBLIC.host_usage (
  "timestamp" TIMESTAMP NOT NULL,
  host_id INT NOT NULL,
  memory_free INT4 NOT NULL,
  cpu_idle INT2 NOT NULL,
  cpu_kernel INT2 NOT NULL,
  disk_io INT4 NOT NULL,
  disk_available INT4 NOT NULL,
  FOREIGN KEY (host_id) REFERENCES host_info(id)
);

-- Insert sample data into host_usage table
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) 
VALUES 
('2019-05-29 15:00:00.000', 1, 300000, 90, 4, 2, 3),
('2019-05-29 15:01:00.000', 1, 200000, 90, 4, 2, 3)
ON CONFLICT DO NOTHING;

