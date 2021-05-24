select dealers.company as dealer, partner_reports.year, sum(results.units) as total_units, sum(results.sales) as total_sales, sum(results.amount) as total_amount
from results
         inner join dealers on dealers.id = results.dealer_id
         inner join partner_reports on partner_reports.id = results.partner_report_id
         inner join partners on partners.id = partner_reports.partner_id
group by dealers.company, partner_reports.year