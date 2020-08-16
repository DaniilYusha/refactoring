module AccountRegistrator
  CREATE_COMMAND = I18n.t('commands.create')
  LOAD_COMMAND = I18n.t('commands.load')

  def pull_out_current_account
    outputer.introduction
    action = gets.chomp
    return create if action == CREATE_COMMAND
    return load if action == LOAD_COMMAND

    exit
  end

  def create
    loop do
      account = Account.new name: name_input, age: age_input, login: login_input, password: password_input
      next show_errors account.errors unless account.valid?

      AccountManager.add(account)
      return account
    end
  end

  def load
    loop do
      return create_the_first_account unless AccountManager.accounts?

      login = login_input
      password = password_input
      return AccountManager.find_by_login(login) if AccountManager.exists? login, password

      next outputer.no_account
    end
  end

  def create_the_first_account
    outputer.offer_create_first_account
    gets.chomp == MainMenu::YES_ANSWER ? create : start
  end

  private

  def name_input
    outputer.enter_name
    gets.chomp
  end

  def age_input
    outputer.enter_age
    gets.chomp.to_i
  end

  def login_input
    outputer.enter_login
    gets.chomp
  end

  def password_input
    outputer.enter_password
    gets.chomp
  end

  def show_errors(errors)
    errors.each { |error| puts error }
    errors.clear
  end
end
