# Poultry Business Manager Cloud

यह GitHub Pages + Supabase के लिए तैयार web app है।

## क्या मिलेगा
- Email/password login
- Cloud database
- दूसरे mobile से वही account/data
- Daily eggs/feed
- Sales
- Expenses
- Bird mortality/addition/sale
- Feed/egg/tray stock
- Automatic profit/loss
- Cost per egg
- 7-day profit chart
- Owner settings

## एक बार setup

### 1) Supabase project
https://supabase.com/ पर free project बनाओ।

### 2) Database
Supabase Dashboard > SQL Editor में `supabase_schema.sql` की पूरी SQL paste करके Run करो।

### 3) API keys
Supabase Dashboard > Project Settings > API में:
- Project URL
- Publishable/anon key

कॉपी करो।

### 4) index.html
`index.html` में:
`PASTE_SUPABASE_URL_HERE`
और
`PASTE_SUPABASE_ANON_KEY_HERE`
को अपनी values से replace करो।

### 5) GitHub Pages
इस folder की files GitHub repository में upload करो:
- index.html
- manifest.webmanifest
- supabase_schema.sql
- README.md

GitHub > Settings > Pages > Deploy from branch > main > root > Save.

कुछ मिनट बाद GitHub Pages URL मिल जाएगा।

## जरूरी
Supabase anon/publishable key frontend में रखना सामान्य है; database security RLS policies से होती है। Service-role/secret key कभी frontend में मत डालना।

## Future upgrade ideas
- Monthly/annual reports
- WhatsApp alerts
- Multiple workers
- Purchase ledger
- Customer credit
- Egg inventory auto-calculation
- PDF/Excel reports
