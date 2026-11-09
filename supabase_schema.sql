-- POULTRY BUSINESS MANAGER CLOUD
-- Run this entire SQL in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  initial_investment numeric not null default 23000,
  starting_birds integer not null default 100,
  updated_at timestamptz not null default now()
);

create table if not exists public.daily_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  live_birds integer not null default 0,
  good_eggs integer not null default 0,
  broken_eggs integer not null default 0,
  feed_kg numeric not null default 0,
  feed_rate numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  egg_qty integer not null default 0,
  egg_rate numeric not null default 0,
  other_income numeric not null default 0,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  category text not null,
  amount numeric not null default 0,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.bird_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  added integer not null default 0,
  dead integer not null default 0,
  sold integer not null default 0,
  sale_income numeric not null default 0,
  note text,
  created_at timestamptz not null default now()
);

create table if not exists public.stock (
  user_id uuid primary key references auth.users(id) on delete cascade,
  feed_kg numeric not null default 0,
  egg_trays integer not null default 0,
  egg_stock integer not null default 0,
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.daily_entries enable row level security;
alter table public.sales enable row level security;
alter table public.expenses enable row level security;
alter table public.bird_entries enable row level security;
alter table public.stock enable row level security;

drop policy if exists profiles_owner on public.profiles;
create policy profiles_owner on public.profiles for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists daily_owner on public.daily_entries;
create policy daily_owner on public.daily_entries for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists sales_owner on public.sales;
create policy sales_owner on public.sales for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists expenses_owner on public.expenses;
create policy expenses_owner on public.expenses for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists birds_owner on public.bird_entries;
create policy birds_owner on public.bird_entries for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

drop policy if exists stock_owner on public.stock;
create policy stock_owner on public.stock for all using (auth.uid()=user_id) with check (auth.uid()=user_id);

-- Optional: create a default profile automatically when a user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path=public
as $$
begin
  insert into public.profiles(user_id) values(new.id)
  on conflict do nothing;
  insert into public.stock(user_id) values(new.id)
  on conflict do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
