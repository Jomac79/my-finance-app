-- My Finance v2 - Supabase schema
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz default now()
);

create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  tx_date date not null,
  category text not null,
  amount numeric(12,2) not null,
  note text,
  created_at timestamptz default now()
);

create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  account_type text not null,
  balance numeric(14,2) not null default 0,
  updated_at timestamptz default now()
);

create table if not exists mortgage (
  user_id uuid primary key references auth.users(id) on delete cascade,
  balance numeric(14,2) not null,
  annual_rate numeric(8,5) not null,
  monthly_payment numeric(14,2) not null,
  payments_left integer not null,
  updated_at timestamptz default now()
);

create table if not exists income (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  year integer not null,
  month integer not null,
  amount numeric(12,2) not null default 0,
  unique(user_id,year,month)
);

alter table income enable row level security;
create policy "income own rows" on income for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create table if not exists budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  year integer not null,
  month integer not null,
  category text not null,
  amount numeric(12,2) not null,
  unique(user_id,year,month,category)
);

alter table profiles enable row level security;
alter table transactions enable row level security;
alter table accounts enable row level security;
alter table mortgage enable row level security;
alter table budgets enable row level security;

create policy "profiles own row" on profiles for all using (id = auth.uid()) with check (id = auth.uid());
create policy "transactions own rows" on transactions for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "accounts own rows" on accounts for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "mortgage own row" on mortgage for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "budgets own rows" on budgets for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles(id) values (new.id) on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users for each row execute procedure public.handle_new_user();

create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  target_amount numeric(14,2) not null default 0,
  current_amount numeric(14,2) not null default 0,
  deadline date not null,
  source text not null default 'manual',
  starting_amount numeric(14,2) not null default 0,
  updated_at timestamptz default now()
);

alter table goals enable row level security;
create policy "goals own rows" on goals for all using (user_id = auth.uid()) with check (user_id = auth.uid());
