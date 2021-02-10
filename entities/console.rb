class Console
  include AccountRegistrator
  include MainMenu

  attr_reader :outputer, :current_account

  def initialize
    @outputer = OutputService.new
  end

  def start
    @current_account = pull_out_current_account

    main_menu
  end
end
