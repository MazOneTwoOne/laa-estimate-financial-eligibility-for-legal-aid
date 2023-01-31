require "rails_helper"

RSpec.describe "Level of help page" do
  let(:level_of_help_header) { I18n.t("estimate_flow.level_of_help.title") }

  context "when controlled is not enabled" do
    it "does not show this page" do
      visit_first_page
      expect(page).not_to have_content level_of_help_header
    end
  end

  context "when controlled is enabled", :controlled_flag do
    let(:mock_connection) do
      instance_double(CfeConnection, create_proceeding_type: nil, create_applicant: nil, api_result: calculation_result)
    end
    let(:calculation_result) { CalculationResult.new FactoryBot.build(:api_result) }

    it "shows this page first" do
      visit_first_page
      expect(page).to have_content level_of_help_header
    end

    it "shows an error if nothing is selected" do
      visit_first_page
      click_on "Save and continue"
      expect(page).to have_content level_of_help_header
      expect(page).to have_content "Select the level of help your client needs"
    end

    it "tells CFE if I choose controlled" do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      expect(mock_connection).to receive(:create_assessment_id).with({ submission_date: Time.zone.today, level_of_representation: "controlled" })
      visit_check_answers(passporting: true) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        end
      end

      click_on "Submit"
    end

    it "hides annual employment frequency if I select controlled" do
      visit_flow_page(passporting: false, target: :employment) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        when :applicant
          select_boolean(page:, form_name: "applicant-form", field: :over_60, value: false)
          select_boolean(page:, form_name: "applicant-form", field: :passporting, value: false)
          select_boolean(page:, form_name: "applicant-form", field: :employed, value: true)
          click_on "Save and continue"
        end
      end

      expect(page).not_to have_content "Total in last 3 months"
      expect(page).not_to have_content "Every year"
    end
  end
end
