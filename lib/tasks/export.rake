# frozen_string_literal: true

namespace :export do
  task load_last_year: :environment do
    require 'csv'

    @last_year = {}
    csv = CSV.read('db/2019_report.csv', headers: true)
    @last_hear_headers = csv.headers - %w[id dealer]
    csv.each do |raw_row|
      row = raw_row.to_h
      @last_year[row['id'].to_i] = @last_hear_headers.map { |h| row[h] }
    end
  end

  task report: ['import:setup', :load_last_year] do
    header = []
    header << 'Dealer ID'
    header << 'Dealer Name'
    header << 'Contact'

    @last_hear_headers.each do |h|
      header << "2019 - #{h}"
    end

    Partner.order(:name).each do |partner|
      partner.partner_reports.where(year: 2020).each do |partner_report|
        header << "2020 #{partner.name} #{partner_report.type} Sales"
        header << "2020 #{partner.name} #{partner_report.type} Units"
        header << "2020 #{partner.name} #{partner_report.type} Return"
        if partner.id == @ntp_partner_id
          header << '2020 NTP Rebate'
          header << '2020 NTP Savings'
        end
        header << '2020 Wells Savings' if partner.id == @wells_fargo_partner_id
      end
    end
    header.flatten!

    puts header.join(',')

    Dealer.order(:company).each do |dealer|
      row = []
      row << dealer.id
      row << dealer.company
      row << dealer.staffs&.first&.name

      last_year_row = @last_year[dealer.id]

      @last_hear_headers.each_with_index do |_, i|
        row << if last_year_row.nil?
                 0
               else
                 last_year_row[i]
               end
      end

      Partner.order(:name).each do |partner|
        partner.partner_reports.where(year: 2020).each do |partner_report|
          result = Result.find_by(dealer: dealer, partner_report: partner_report)
          row << partner_report.sales.where(dealer: dealer).sum(:value)
          row << partner_report.units.where(dealer: dealer).sum(:value)
          row << if result.present?
                   result.amount
                 else
                   0
                 end
          next unless partner.id == @ntp_partner_id || partner.id == @wells_fargo_partner_id

          sales = partner_report.sales.where(dealer: dealer).where.not(extra: nil).order(:reported_on).last
          if partner.id == @ntp_partner_id
            row << if sales.present?
                     sales.extra['rebate']
                   else
                     0
                   end

            row << if sales.present?
                     sales.extra['savings']
                   else
                     0
                   end
          end

          next unless partner.id == @wells_fargo_partner_id

          row << if sales.present?
                   sales.extra['savings']
                 else
                   0
                 end
        end
      end
      puts row.join(',')
    end
  end
end
