module Secured
  def authenticate_user!
      token_regex = /Bearer (\w+)/
      headers = request.headers
      if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
        token = headers['Authorization'].match(token_regex)[1]
        if (Current.user = User.find_by_auth_token(token))
          return
        end
      end

      render json: {error: 'unauthorized'}, status: :unauthorized
  end

  def user_from_token
    # Obtener el token del header Authorization
    token = get_token_from_auth_header
    # Utilizar JsonWebToken para verificar y validar el token
    payload = JsonWebToken.verify(token).first.with_indifferent_access
    if payload.present?
      # Si existe un token buscamos un usuario con el email contenido en el token.
      # Si todavia no existe un usuario con este email, se crea usando el metodo `find_or_create_by`
      # de ActiveRecord.
      User.find_or_create_by(email: payload[:email]) do |user|
        user.name = payload[:name]
      end
    end
  end
 
  def get_token_from_auth_header
    # IMPORTANTE! cambiar el regex que teniamos antes. Como JWT incluye puntos, el regex anterior
    # no tenia encuenta puntos.
    token_regex = /Bearer (.+)/
    # leer HEADER de auth
    headers = request.headers
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      headers['Authorization'].match(token_regex)[1]
    end
  end
end