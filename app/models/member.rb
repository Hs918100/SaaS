class Member < ApplicationRecord
  belongs_to :user
  belongs_to :tenant

  validates :tenant, presence: true
  validates_uniqueness_of :user_id, scope: :tenant_id
end
