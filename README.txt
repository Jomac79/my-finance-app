My Finance App - Version 4

Version 4 adds:
- Goals: create manual or linked financial goals with target amount and deadline.
- Automatic goal progress for net worth, investments, crypto, mortgage balance, and cash/savings.
- Monthly amount needed to reach each goal by its target date.
- Mortgage goals can use a starting balance so progress is measured as the loan falls.
- Budget section with editable allocation percentages and budget-vs-actual view.
- Local backup export now includes goals and budget settings.
- Supabase schema now includes a goals table with Row Level Security.

How to use locally:
1. Unzip this folder.
2. Open index.html in a browser. Some browsers may block fetch() from file://; if so, serve the folder with a simple local web server.
3. Your original workbook-derived data is included in data.json.

Cloud sync:
- This build includes the Supabase schema and connection fields, but live authentication/synchronization is not automatically activated.
- To use cloud sync, create a Supabase project, run supabase_schema.sql in its SQL editor, then configure the project URL and anon key in More.
- Never use a Supabase service-role key in the browser.
