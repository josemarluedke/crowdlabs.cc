class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale
  before_filter :detect_locale

  def set_locale
    return unless params[:locale]
    I18n.locale = params[:locale]
  end

  def detect_locale
    return unless request.method == "GET"
    return if params[:locale]
    return redirect_to replace_locale(I18n.default_locale.to_s)
  end

  def replace_locale(new_locale)
    session[:locale] = new_locale
    new_url = "#{request.fullpath}"
    if params[:locale]
      new_url.gsub!(/^\/#{params[:locale]}/, "/#{new_locale}")
    else
      if new_url == "/"
        new_url = "/#{new_locale}"
      else
        new_url[0] = "/#{new_locale}/"
      end
    end
    new_url
  end
end
