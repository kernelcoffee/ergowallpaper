class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
  :registerable,
	:recoverable,
	:rememberable,
	:trackable,
	:validatable

  has_many :favorites

  has_many :wallpapers
  has_many :albums
  has_one :album, as: :favorite
end