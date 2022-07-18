class ApplicationController < ActionController::Base
  
  #skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :verify_authenticity_token, only: :saml_callback
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  #protect_from_forgery with: exception
  #before_action :authenticate_user!, except: [:home]
  
  #metodo para cambio de contraseña en primer login
  def after_sign_in_path_for(resource)
    #current_user.update(passwordreset: true)
    if current_user.passwordreset == true
      
      token = current_user.send(:set_reset_password_token)
      sign_out(current_user)
      #puts user_signed_in?
      flash[:notice] = 'Debes cambiar tu contraseña al iniciar sesion por primera vez'
      edit_password_path(:user, reset_password_token: token)
    
    else
      
      root_path
    end
  end


  def saml_login
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(saml_settings))
  end

  def saml_callback
    response = OneLogin::RubySaml::Response.new(
      params[:SAMLResponse],
      allowed_clock_drift: 100,
      :settings => saml_settings
    )
  
    if response.is_valid?
      @user = User.find_by(email: response.name_id)
      @user ||= User.new(email: response.name_id, client_id: Client.last.id, password: "password")
      @user.save! if !@user.persisted? #checkea con persisted? si esta guardado en la bd
      sign_in(@user)
      redirect_to("http://localhost:3000/articles")
    else
      raise response.errors.inspect
    end
  end
  
  protected
  #metodo para asignar mas parametros al usuario de devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:timeoutminutes, :client_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:timeoutminutes, :client_id])
  end

  private

  def saml_settings

    settings = OneLogin::RubySaml::Settings.new
    #settings.allowed_clock_drift = 100
    

    # You provide to IDP
    settings.assertion_consumer_service_url = "onelogin"
    settings.sp_entity_id                   = "http://localhost:3000/"
    
    # IDP provides to you
    settings.idp_sso_target_url             = "https://pruebaa-dev.onelogin.com/trust/saml2/http-post/sso/43473a9d-d420-42ca-9e4e-80c49c171392"
    settings.idp_cert                       = "-----BEGIN CERTIFICATE-----
    MIID4jCCAsqgAwIBAgIUU8t2N14xhdfhUH//iQxQ6s3dtnUwDQYJKoZIhvcNAQEF
    BQAwRzESMBAGA1UECgwJZmluYW50ZWNoMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAx
    GjAYBgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMB4XDTIyMDcwNDE2MTQ0MFoXDTI3
    MDcwNDE2MTQ0MFowRzESMBAGA1UECgwJZmluYW50ZWNoMRUwEwYDVQQLDAxPbmVM
    b2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxvZ2luIEFjY291bnQgMIIBIjANBgkqhkiG
    9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoEfoe8ps2g8zkJmzwCJU5752kHxeLpL24eIZ
    IdSnqCN3a8fsMNfwj/0MgQzMcFqnpS61/DgnBoUjBB7sAiS8MY03cOVXd/cS74M7
    /g4Q2M9bFlzj6nCgA9I7Iqj4yLxmklyu5vl+cpPWKc971lUCGYs2IYO3HzlUFCvT
    1FlXPy7akyQ6NDYPEGZYNcO7Hj9k5IAtwySKT0KNqL+RJs0DgQf75VHW754aDQKf
    BYNpk7lluzoRjdQJOVck2W2RVHaAEfBaCtrWUTnv+k3c0oFZI9W6SEUQs/bK0BFZ
    ed3kj+ilIyqTxvW3A2J26trGzDcfrbGdPY7lYOnokK6xjCMtoQIDAQABo4HFMIHC
    MAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFNdYfPVfgd/tE+7IGse4BpjICrdDMIGC
    BgNVHSMEezB5gBTXWHz1X4Hf7RPuyBrHuAaYyAq3Q6FLpEkwRzESMBAGA1UECgwJ
    ZmluYW50ZWNoMRUwEwYDVQQLDAxPbmVMb2dpbiBJZFAxGjAYBgNVBAMMEU9uZUxv
    Z2luIEFjY291bnQgghRTy3Y3XjGF1+FQf/+JDFDqzd22dTAOBgNVHQ8BAf8EBAMC
    B4AwDQYJKoZIhvcNAQEFBQADggEBABNPL7YotblBV9L1SygsMOIVPn7ygIFzOdjr
    JZMUrBpJhrxS0+E4bkI/LgcHW8kUcDAqhwloAyDrhzfQs4SF5j54QFI6+u+dHuKa
    CTXmOKC7p1Px0sbJnBv7pYouA9iAUy4BPZl8J7hYXyW+WVSLfrGFooyUYJ1pgHTt
    BHaqQCJ0pVW7qhVFhdfbO9yL4bmveLMf3z60LZXY7fIOa+8rwlNnMU7U3huGiab7
    gkGXnX46dNm68/argF2fSIi5BvJBsPqKBk9bOSBFozJJpQmOI7w2X6yB+kLo1XmB
    sIpc2lu8jFwuvmpc5GQZHcG8r5CeQZ6qkvO4t40BzsL9MHnwX/I=
    -----END CERTIFICATE-----"
    
    settings
  end
    
end
