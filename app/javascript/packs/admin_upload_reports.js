document.addEventListener('turbolinks:load', function(){
  let partnerSelect = document.querySelector('#report_upload_partner_id');
  let yearSelectOptions = document.querySelectorAll('input[name="report_upload[year]"]');

  partnerSelect.addEventListener('change', updateExample);

  for (yearOption of yearSelectOptions) {
    yearOption.addEventListener('click', updateExample);
  }

  updateExample();
});


function updateExample() {
  console.log("Update Example");

  let partnerId = document.querySelector('#report_upload_partner_id').value;
  let year = document.querySelector('input[name="report_upload[year]"]:checked').value;

  console.log("partner_id:", partnerId, 'year:', year);

  let reportInfo = document.getElementById(`${partnerId}-${year}`);
  let samp = document.querySelector('samp');
  let quickReport = document.querySelector('#quick-report');

  if (reportInfo === null) {
    quickReport.innerHTML = `Selected partner doesn't have the report for ${year} year`
    samp.innerHTML = '...';
  } else {
    quickReport.innerHTML = reportInfo.dataset.quickReport;
    samp.innerHTML = reportInfo.dataset.example;
  }
}
