class UsualCard < BaseCard
  def initialize(account)
    super

    @type = 'usual'
    @balance = 50.00
  end

  private

  def withdraw_percent
    5
  end

  def put_percent
    2
  end

  def sender_fixed
    20
  end
end
