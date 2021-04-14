# frozen_string_literal: true

namespace :import do
  task setup: :environment do
    @sal_partner_id = 30
    @east_penn_partner_id = 32
    @td_partner_id = 47
    @coach_net_partner_id = 48
    @wells_fargo_partner_id = 50
    @cole_international_partner_id = 51
    @ids_partner_id = 52
    @boss_partner_id = 53
    @ntp_partner_id = 54
    @eco_sol_planet_partner_id = 55
    @blue_ox_partner_id = 56
    @springwall_partner_id = 57
    @kuma_partner_id = 58
    @healthguard_partner_id = 59
    @prefera_partner_id = 60

    @period_to_month_number = {
      'Jan' => 1,
      'Feb' => 2,
      'Mar' => 3,
      'Apr' => 4,
      'May' => 5,
      'Jun' => 6,
      'Jul' => 7,
      'Aug' => 8,
      'Sep' => 9,
      'Oct' => 10,
      'Nov' => 11,
      'Dec' => 12,
      '1stQuarterWarrenty' => 3,
      '2ndQuarterWarrenty' => 6,
      '3rdQuarterWarrenty' => 9,
      '4thQuarterWarrenty' => 12,
      '1stQtrCC' => 3,
      '2ndQtrCC' => 6,
      '3rdQtrCC' => 9,
      '4thQtrCC' => 12,
      '1stQtrOther' => 3,
      '2ndQtrOther' => 6,
      '3rdQtrOther' => 9,
      '4thQtrOther' => 12
    }.freeze

    @default_period_to_entry_type = {
      'Jan' => 'Sales',
      'Feb' => 'Sales',
      'Mar' => 'Sales',
      'Apr' => 'Sales',
      'May' => 'Sales',
      'Jun' => 'Sales',
      'Jul' => 'Sales',
      'Aug' => 'Sales',
      'Sep' => 'Sales',
      'Oct' => 'Sales',
      'Nov' => 'Sales',
      'Dec' => 'Sales',
      '1stQuarterWarrenty' => 'Units',
      '2ndQuarterWarrenty' => 'Units',
      '3rdQuarterWarrenty' => 'Units',
      '4thQuarterWarrenty' => 'Units',
      '1stQtrCC' => 'Units',
      '2ndQtrCC' => 'Units',
      '3rdQtrCC' => 'Units',
      '4thQtrCC' => 'Units',
      '1stQtrOther' => 'Units',
      '2ndQtrOther' => 'Units',
      '3rdQtrOther' => 'Units',
      '4thQtrOther' => 'Units'
    }.freeze

    @sal_report_types = {
      'Mar' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      'Jun' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      'Sep' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      'Dec' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      '1stQuarterWarrenty' => OpenStruct.new(type: 'SalWarrantyReport', parameters: SalWarrantyReport.new.default_parameters),
      '2ndQuarterWarrenty' => OpenStruct.new(type: 'SalWarrantyReport', parameters: SalWarrantyReport.new.default_parameters),
      '3rdQuarterWarrenty' => OpenStruct.new(type: 'SalWarrantyReport', parameters: SalWarrantyReport.new.default_parameters),
      '4thQuarterWarrenty' => OpenStruct.new(type: 'SalWarrantyReport', parameters: SalWarrantyReport.new.default_parameters),
      '1stQtrCC' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      '2ndQtrCC' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      '3rdQtrCC' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      '4thQtrCC' => OpenStruct.new(type: 'SalCreditorReport', parameters: SalCreditorReport.new.default_parameters),
      '1stQtrOther' => OpenStruct.new(type: 'SalOtherReport', parameters: SalOtherReport.new.default_parameters),
      '2ndQtrOther' => OpenStruct.new(type: 'SalOtherReport', parameters: SalOtherReport.new.default_parameters),
      '3rdQtrOther' => OpenStruct.new(type: 'SalOtherReport', parameters: SalOtherReport.new.default_parameters),
      '4thQtrOther' => OpenStruct.new(type: 'SalOtherReport', parameters: SalOtherReport.new.default_parameters)
    }.freeze

    @report_types = {
      @wells_fargo_partner_id => OpenStruct.new(type: 'WellsFargoReport', parameters: WellsFargoReport.new.default_parameters),
      @ntp_partner_id => OpenStruct.new(type: 'NtpReport', parameters: NtpReport.new.default_parameters),
      @td_partner_id => OpenStruct.new(type: 'TdBankReport', parameters: TdBankReport.new.default_parameters),
      @east_penn_partner_id => OpenStruct.new(type: 'EastPennReport', parameters: EastPennReport.new.default_parameters),
      @blue_ox_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                              'sales_multiplier' => 0.01,
                                              'dealer_share_multiplier' => 0.0
                                            }),
      @cole_international_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                                         'sales_multiplier' => 0.075,
                                                         'dealer_share_multiplier' => 0.6
                                                       }),
      @ids_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                          'sales_multiplier' => 0.04,
                                          'dealer_share_multiplier' => 0.6
                                        }),
      @springwall_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                                 'sales_multiplier' => 0.04,
                                                 'dealer_share_multiplier' => 0.0
                                               }),
      @boss_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                           'sales_multiplier' => 0.03,
                                           'dealer_share_multiplier' => 0.0
                                         }),
      @eco_sol_planet_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                                     'sales_multiplier' => 0.0375,
                                                     'dealer_share_multiplier' => 0.0
                                                   }),
      @kuma_partner_id => OpenStruct.new(type: 'SimpleSalesReport', parameters: {
                                           'sales_multiplier' => 0.02,
                                           'dealer_share_multiplier' => 0.0
                                         }),
      @coach_net_partner_id => OpenStruct.new(type: 'SimpleUnitsReport', parameters: {
                                                'contract_value' => 4,
                                                'dealer_share_multiplier' => 0.6
                                              }),
      @prefera_partner_id => OpenStruct.new(type: 'SimpleUnitsReport', parameters: {
                                              'contract_value' => 30,
                                              'dealer_share_multiplier' => 0.0
                                            })
    }.freeze

    def find_report_type(row, period)
      return @sal_report_types[period] if row['PartnerID'] == @sal_partner_id

      type = @report_types[row['PartnerID']]
      type = OpenStruct.new(type: 'BlankReport', parameters: {}) if type.nil?
      type
    end

    def find_or_create_partner_report(row, period)
      type = find_report_type(row, period)

      PartnerReport.find_or_create_by!(partner_id: row['PartnerID'], year: row['EntryYear'], type: type.type) do |partner_report|
        partner_report.parameters = type.parameters
      end
    end

    def period_type(period, row, partner_report)
      return 'Units' if row['PartnerID'] == @td_partner_id
      return 'Units' if partner_report.type == 'SimpleUnitsReport'

      @default_period_to_entry_type[period]
    end

    @td_extras = {
      market: {
        2019 => %w[Yes No	No No No No No No No No Yes	Yes],
        2020 => %w[Yes Yes Yes Yes Yes Yes Yes No Yes Yes Yes Yes]
      },
      first_look: {
        2019 => %w[Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes],
        2020 => %w[Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes Yes]
      }
    }.freeze

    def entry_extra_for(partner_id:, year:, month_number:)
      return if partner_id != @td_partner_id

      {
        'market_share_reached' => @td_extras[:market][year][month_number - 1] == 'Yes',
        'first_look' => @td_extras[:first_look][year][month_number - 1] == 'Yes'
      }
    end
  end

  task dealers: :setup do
    puts 'Importing Dealers...'
    db = SQLite3::Database.new Rails.root.join('db/seed_entries.sqlite').to_s
    sql = <<~END_SQL
      SELECT DealerID, Company, LegalName, MailingAddress, City, Province, PostalCode, Phone, TollFree, FaxNumber, Email,
          LocAddress, LocCity, LocProvince, LocPostalCode, Website, DateJoined, Shareholder, Director, AtlasAccount, DometicAccount,
          WellsFargoAccount, KeystoneAccount, TDSortOrder, SALAccount, MegaGroupAccount, BossAccount, DMSSystem, CRMSystem,
          EmployeeBenefitsProvider, CustomsBroker, RVTransport, DigitalMarketing, RVBrands, Status FROM tblDealers
    END_SQL
    db.execute(sql) do |raw_row|
      row = {
        company: raw_row[1],
        legal_name: raw_row[2],
        mailing_address: raw_row[3],
        city: raw_row[4],
        province: raw_row[5],
        postal_code: raw_row[6],
        phone: raw_row[7],
        toll_free: raw_row[8],
        fax_number: raw_row[9],
        email: raw_row[10],
        location_address: raw_row[11],
        location_city: raw_row[12],
        location_province: raw_row[13],
        location_postal_code: raw_row[14],
        website: raw_row[15],
        date_joined: raw_row[16],
        shareholder: raw_row[17],
        director: raw_row[18],
        atlas_account: raw_row[19],
        dometic_account: raw_row[20],
        wells_fargo_account: raw_row[21],
        keystone_account: raw_row[22],
        td_sort_order: raw_row[23],
        sal_account: raw_row[24],
        mega_group_account: raw_row[25],
        boss_account: raw_row[26],
        dms_system: raw_row[27],
        crm_system: raw_row[28],
        employee_benefits_provider: raw_row[29],
        customs_broker: raw_row[30],
        rv_transport: raw_row[31],
        digital_marketing: raw_row[32],
        rv_brands: raw_row[33],
        status: raw_row[34]
      }
      dealer = Dealer.new
      dealer.id = raw_row[0].to_i
      dealer.save!
      dealer.update!(row)
      print '.'
    end
  end

  task clear_reports: :setup do
    puts 'Clearing entries and partner reports...'
    Entry.destroy_all
    Result.destroy_all
    PartnerReport.destroy_all
    Staff.destroy_all
    Dealer.destroy_all
  end

  task numbers: %i[clear_reports dealers ntp_account_numbers] do
    require 'date'
    require 'sqlite3'
    puts 'Importing...'
    count = 0

    level5_partner = Partner.find_or_create_by!(name: 'Level 5 Advertising')
    level5_partner_report = PartnerReport.find_or_create_by!(
      partner_id: level5_partner.id,
      year: 2020,
      type: 'SimpleSalesReport',
      parameters: {
        'sales_multiplier' => 0.05,
        'dealer_share_multiplier' => 0.6
      }
    )

    CSV.foreach('db/level5_2020.csv', headers: true) do |raw_row|
      row = raw_row.to_h
      dealer_id = row['dealer_id'].to_i
      month = row['period'].to_i
      value = row['value'].to_f.round

      puts(count) if (count % 80).zero?
      print('.')
      count += 1

      Entry.create!(
        partner_report: level5_partner_report,
        dealer_id: dealer_id,
        reported_on: Date.civil(2020, month, -1),
        value: value,
        type: 'Sales'
      )
    end

    db = SQLite3::Database.new Rails.root.join('db/seed_entries.sqlite').to_s
    sql = "SELECT PartnerID, DealerID, EntryYear, #{@period_to_month_number.keys.map { |m| "`#{m}`" }.join(',')} FROM tblParticipationNumbers WHERE EntryYear = 2019 OR EntryYear = 2020"
    db.execute(sql) do |raw_row|
      row = {
        'PartnerID' => raw_row[0],
        'DealerID' => raw_row[1],
        'EntryYear' => raw_row[2]
      }

      @period_to_month_number.keys.each_with_index do |period, index|
        row[period] = raw_row[3 + index]
      end
      @period_to_month_number.each do |period, month_number|
        next if row[period].round.zero?

        puts(count) if (count % 80).zero?
        print('.')
        count += 1
        partner_report = find_or_create_partner_report(row, period)
        Entry.create!(
          partner_report_id: partner_report.id,
          dealer_id: row['DealerID'],
          reported_on: Date.civil(row['EntryYear'].to_i, month_number, -1),
          value: row[period].round,
          type: period_type(period, row, partner_report),
          extra: entry_extra_for(partner_id: row['PartnerID'], year: row['EntryYear'].to_i, month_number: month_number)
        )
      end
    end

    puts count
    puts 'Caching results ...'
    PartnerReport.cache_all!
    puts 'Done!'
  end

  task ntp_account_numbers: :setup do
    csv = CSV.read('db/ntp_account_numbers.csv', headers: true)

    csv.each do |raw_row|
      row = raw_row.to_h
      Dealer.find(row['id']).update!(ntp_account: row['ntp_account'])
    end
  end

  task ntp_extra: :ntp_account_numbers do
    partner = Partner.find(@ntp_partner_id)
    partner_report = PartnerReport.find_by(partner_id: partner.id, year: '2020')
    Money.default_currency = 'CAD'
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP

    CSV.foreach('db/ntp_extra.csv', headers: true) do |raw_row|
      row = raw_row.to_h
      dealer = Dealer.find_by(ntp_account: row['id'])
      next puts "No dealer: #{row['id']}" if dealer.nil?

      sales = Sales.where(dealer_id: dealer.id, partner_report_id: partner_report.id).order(:reported_on).last

      next puts "No sales for dealer: #{dealer.id} #{dealer.company}" if sales.nil?

      rebate = Monetize.parse(row['amount']).cents / 100
      sales.extra = {} if sales.extra.nil?

      sales.extra['rebate'] = rebate

      savings = Sales.where(dealer_id: dealer.id, partner_report_id: partner_report.id).sum(:value) * 0.07
      sales.extra['savings'] = savings.round

      sales.save!
    end
  end

  task wells_extra: :setup do
    puts 'Import Wells extra'
    partner = Partner.find(@wells_fargo_partner_id)
    partner_report = PartnerReport.find_by(partner_id: partner.id, year: '2020')

    CSV.foreach('db/wells_extra.csv', headers: true) do |raw_row|
      row = raw_row.to_h
      next print '.' unless row['savings'] == 'x'

      dealer = Dealer.find_by(company: row['name'])

      next puts "No dealer: #{row['name']}" if dealer.nil?

      sales = Sales.where(dealer_id: dealer.id, partner_report_id: partner_report.id).order(:reported_on).last

      next puts "No sales for dealer: #{dealer.id} #{dealer.company}" if sales.nil?

      amount = Sales.where(dealer_id: dealer.id, partner_report_id: partner_report.id).sum(:value) * 0.0025
      sales.extra = {} if sales.extra.nil?
      sales.extra['savings'] = amount.round
      sales.save!
    end
    puts ''
  end

  task staff: :setup do
    db = SQLite3::Database.new Rails.root.join('db/seed_entries.sqlite').to_s
    sql = 'SELECT DealerID,FirstName,LastName,Position1,Email,PersonID FROM tblStaff'
    db.execute(sql) do |raw_row|
      row = {
        dealer_id: raw_row[0],
        first_name: raw_row[1],
        last_name: raw_row[2],
        position: raw_row[3],
        email: raw_row[4],
        access_id: raw_row[5]
      }
      begin
        Staff.create!(row)
      rescue StandardError
        puts "Failed to add staff: #{raw_row.inspect}"
      end
    end
  end

  task all: %i[numbers staff ntp_extra wells_extra]
end
