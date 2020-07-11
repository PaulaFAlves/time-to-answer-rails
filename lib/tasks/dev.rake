namespace :dev do

  DEFAULT_PASSWORD = 123456

  desc "Configura ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando banco de dados...") { %x(rails db:drop) }  
      show_spinner("Criando banco de dados") { %x(rails db:create) }
      show_spinner("Migrando tabelas") { %x(rails db:migrate) }   
      show_spinner("Cadastrando administrador padrão...") { %x(rails dev:add_default_admin) }   
      show_spinner("Cadastrando usuário padrão...") { %x(rails dev:add_default_user) }   
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Adiciona administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private

  def show_spinner(msg_start, msg_end = 'Concluído com sucesso!') 
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

end
