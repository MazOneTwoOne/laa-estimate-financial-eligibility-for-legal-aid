class SubmitIrregularIncomeService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    if form.student_finance
      create_student_loan cfe_connection, cfe_estimate_id, form.student_finance
    end

    if form.other
      create_other_income cfe_connection, cfe_estimate_id, form.other
    end
  end

  def create_student_loan(cfe_connection, assessment_id, amount)
    payments = [
      {
        "income_type": "student_loan",
        "frequency": "annual",
        "amount": amount,
      },
    ]
    cfe_connection.create_irregular_income(assessment_id, payments:)
  end

  def create_other_income(cfe_connection, assessment_id, amount)
    payments = [
      {
        "income_type": "unspecified_source_income",
        "frequency": "quarterly",
        "amount": amount,
      },
    ]
    cfe_connection.create_irregular_income(assessment_id, payments:)
  end
end
