CREATE TYPE public.crew_status AS ENUM ('AVAILABLE','ASSIGNED','OFF_DUTY','UNAVAILABLE','INACTIVE');

CREATE TABLE public.crew (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  crew_code text NOT NULL UNIQUE,
  name text NOT NULL,
  role text NOT NULL DEFAULT 'Driver',
  depot text NOT NULL,
  shift text NOT NULL DEFAULT 'Morning (06:00-14:00)',
  status public.crew_status NOT NULL DEFAULT 'AVAILABLE',
  availability text NOT NULL DEFAULT 'Full shift',
  phone text,
  license_valid_till date,
  weekly_hours numeric(5,1) NOT NULL DEFAULT 0 CHECK (weekly_hours >= 0),
  daily_spreadover_hours numeric(4,1) NOT NULL DEFAULT 0 CHECK (daily_spreadover_hours >= 0),
  consecutive_days integer NOT NULL DEFAULT 0 CHECK (consecutive_days >= 0),
  punctuality_score numeric(5,2),
  current_assignment text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE public.crew_events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  crew_id uuid NOT NULL REFERENCES public.crew(id) ON DELETE RESTRICT,
  event_type text NOT NULL,
  from_status public.crew_status,
  to_status public.crew_status,
  detail text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX crew_events_crew_id_idx ON public.crew_events (crew_id, created_at DESC);

GRANT SELECT, INSERT, UPDATE ON public.crew TO anon, authenticated;
GRANT ALL ON public.crew TO service_role;
GRANT SELECT, INSERT ON public.crew_events TO anon, authenticated;
GRANT ALL ON public.crew_events TO service_role;

ALTER TABLE public.crew ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crew_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Crew are readable" ON public.crew FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Crew can be added" ON public.crew FOR INSERT TO anon, authenticated WITH CHECK (true);
CREATE POLICY "Crew can be updated" ON public.crew FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Crew history is readable" ON public.crew_events FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "Crew history can be appended" ON public.crew_events FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE TRIGGER crew_set_updated_at BEFORE UPDATE ON public.crew
FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

INSERT INTO public.crew (crew_code, name, role, depot, shift, status, availability, phone, license_valid_till, weekly_hours, daily_spreadover_hours, consecutive_days, punctuality_score, current_assignment) VALUES
('DTC-D-7812','Rameshwar Dayal','Driver','Sukhdev Vihar (EV Central)','Morning (06:00-14:00)','ASSIGNED','On duty till 14:00','+91 98102 33419','2028-11-15',36.5,5.2,4,98.4,'Trip 522-UP-0815'),
('DTC-D-3382','Balwan Singh','Driver','Sarojini Nagar Depot','Morning (06:00-14:00)','ASSIGNED','On duty till 14:00','+91 98114 90123','2027-04-20',41.0,6.8,5,94.1,'Trip 505-UP-1030'),
('DTC-D-5521','Sanjay Kumar','Driver','Anand Vihar ISBT Depot','Morning (06:00-14:00)','ASSIGNED','On duty till 14:00','+91 98731 55601','2029-01-10',32.0,4.5,3,96.8,'Trip TMS-CL-0900'),
('DTC-D-9082','Devinder Rawat','Driver','Sarojini Nagar Depot','Full day (06:00-22:00)','AVAILABLE','Depot Reserve Tier-1','+91 98188 77209','2028-08-30',24.0,1.5,2,99.1,NULL),
('DTC-C-1142','Virender Kumar','Conductor','Sukhdev Vihar (EV Central)','Morning (06:00-14:00)','ASSIGNED','On duty till 14:00','+91 98991 22409','2030-05-12',38.0,5.2,4,97.5,'Trip 522-UP-0815'),
('DTC-C-4421','Mahesh Sharma','Conductor','Sarojini Nagar Depot','Morning (06:00-14:00)','ASSIGNED','On duty till 14:00','+91 99105 88921','2029-10-18',42.5,6.8,5,95.0,'Trip 505-UP-1030'),
('DTC-C-6019','Mukesh Tyagi','Conductor','Sarojini Nagar Depot','Full day (06:00-22:00)','AVAILABLE','Depot Reserve Tier-1','+91 98110 44312','2028-12-05',22.0,1.5,2,98.9,NULL),
('DTC-D-4109','Jagdish Chand','Driver','Sukhdev Vihar (EV Central)','Afternoon (14:00-22:00)','OFF_DUTY','Mandatory 45-min break','+91 98109 33902','2027-09-14',28.0,4.0,3,96.2,NULL),
('DTC-D-6231','Dharampal Gill','Driver','Sarojini Nagar Depot','Afternoon (14:00-22:00)','AVAILABLE','Reports 13:30','+91 98115 77120','2029-03-22',30.0,2.0,1,97.2,NULL),
('DTC-C-5541','Deepak Rawat','Conductor','Sarojini Nagar Depot','Afternoon (14:00-22:00)','AVAILABLE','Reports 13:30','+91 98104 66210','2029-06-11',26.5,2.0,1,96.4,NULL),
('DTC-D-8802','Satender Yadav','Driver','Rohini Depot-I','Morning (06:00-14:00)','AVAILABLE','Standby at Rohini-I','+91 98991 40021','2028-02-19',20.0,1.0,1,95.6,NULL),
('DTC-C-7210','Naresh Chand','Conductor','Rohini Depot-I','Morning (06:00-14:00)','UNAVAILABLE','Reported sick leave','+91 98183 55190','2027-12-30',12.0,0.0,0,93.8,NULL),
('DTC-S-2201','Anita Verma','Shift In-Charge','Sukhdev Vihar (EV Central)','Full day (06:00-22:00)','AVAILABLE','Control room supervision','+91 98100 11223','2031-01-05',44.0,7.5,5,99.4,NULL),
('DTC-D-3320','Om Prakash','Driver','Mayapuri Depot','Night (22:00-06:00)','INACTIVE','Long leave','+91 98104 22110','2026-11-01',0.0,0.0,0,90.1,NULL);

INSERT INTO public.crew_events (crew_id, event_type, to_status, detail)
SELECT id, 'CREATED', status, 'Imported from depot roster' FROM public.crew;