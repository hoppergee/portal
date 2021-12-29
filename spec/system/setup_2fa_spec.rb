require 'rails_helper'

RSpec.describe "Setup 2FA on the 'Security' Page" do

  let(:chris) { accounts(:chris) }

  before { sign_in(chris) }

  it "can success setup 2FA and login with it" do
    visit root_path
    expect(page).to have_content("chris's dashboard")

    click_link "Security"
    expect(page).to have_content("Two-factor authentication")

    click_link "Set up two-factor authentication"
    expect(page).to have_content("Two-factor authentication setup")
    expect(page).to have_content("You will need a Google Authenticator(or another 2FA authentication app) to complete this process.")
    expect(page).to have_content("Scan the QR code into your app.")

    click_on "Cancel"
    expect(page).to have_content("Two-factor authentication")
    expect(page.current_path).to eq(account_security_path(chris))

    click_link "Set up two-factor authentication"
    expect(page).to have_content("Two-factor authentication setup")

    token = scan_the_qr_code_and_get_an_onetime_token(chris)
    fill_in_6_digits_field_with token
    click_button "Confirm and activate"
    expect(page).to have_content("2FA Setup Success")
    expect(page).to have_content("Save this emergency backup code and store it somewhere safe. If you lose your phone, you can use backup codes to sign in.")
    expect(page).to have_selector("li", count: 12)
    all("li").each do |li|
      expect(li.text).to match(/\w{8}/)
    end

    click_on "Done"
    expect(page).to have_content("Two-factor authentication")
    expect(page.current_path).to eq(account_security_path(chris))
    expect(page).to have_content("Authenticator app")
    expect(page).to have_content("Enabled")
    expect(page).to have_content("Recovery codes")

    click_button "Regenerate" # Regenerate recovery codes
    expect(page).to have_content("Regenerate Recovery Codes Success")
    expect(page).to have_content("Save this emergency backup code and store it somewhere safe. If you lose your phone, you can use backup codes to sign in. (All previous codes are expired.)")
    expect(page).to have_selector("li", count: 12)
    save_recovery_codes

    click_on "Done"
    expect(page).to have_content("Two-factor authentication")
    expect(page.current_path).to eq(account_security_path(chris))


    ####################
    ## Login with 2FA ##
    ####################

    click_link "Logout"
    expect(page).to have_content("You have been logged out.")

    travel_to 30.seconds.after do
      fill_in 'account[login]', with: 'chris'
      fill_in 'account[password]', with: '12345678'
      click_button "Login"
      expect(page).to have_content("Authenticate your account")
      expect(page).to have_content("Enter 6-digit code from your two factor authenticator app.")

      fill_in_6_digits_field_with '111111'
      click_button "Verify"
      expect(page).to have_content("Failed to authenticate your code")

      token = get_an_onetime_token_from_authenticator_app(chris)
      fill_in_6_digits_field_with token
      click_button "Verify"
      expect(page).to have_content("Welcome chris, it is nice to see you.")
      expect(page.current_path).to eq(dashboard_path)
    end

    ##############################
    ## Login with a backup code ##
    ##############################
    click_link "Logout"
    expect(page).to have_content("You have been logged out.")

    fill_in 'account[login]', with: 'chris'
    fill_in 'account[password]', with: '12345678'
    click_button "Login"
    expect(page).to have_content("Authenticate your account")
    expect(page).to have_content("Enter 6-digit code from your two factor authenticator app.")

    click_link "Use a recovery code to access your account."
    expect(page).to have_content("Authenticate your account with a recovery code")
    expect(page).to have_content("To access your account, enter one of the recovery codes you saved when you set up your two-factor authentication device.")

    fill_in 'account[recovery_code]', with: '123abc'
    click_button "Verify"
    expect(page).to have_content("Failed to authenticate your code")

    fill_in 'account[recovery_code]', with: @recovery_codes.pop
    click_button "Verify"
    expect(page).to have_content("Welcome chris, it is nice to see you.")
    expect(page.current_path).to eq(dashboard_path)
  end

  def scan_the_qr_code_and_get_an_onetime_token(user)
    user.reload.current_otp
  end

  def get_an_onetime_token_from_authenticator_app(user)
    user.reload.current_otp
  end

  def save_recovery_codes
    @recovery_codes = all("li").map(&:text)
  end

  def fill_in_6_digits_field_with(number)
    number_str = number.to_s

    fill_in 'digit-1', with: number_str[0]
    fill_in 'digit-2', with: number_str[1]
    fill_in 'digit-3', with: number_str[2]
    fill_in 'digit-4', with: number_str[3]
    fill_in 'digit-5', with: number_str[4]
    fill_in 'digit-6', with: number_str[5]
  end

end
