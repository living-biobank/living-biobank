class UserPermissionsMailer < ApplicationMailer
  def permissions_changed(user, changes)
    @user = user

    @admin_change =
      if changes[:admin].present?
        if changes[:admin].first == false
          t(:mailers)[:user_permissions_mailer][:admin_granted]
        else
          t(:mailers)[:user_permissions_mailer][:admin_removed]
        end
      else
        nil
      end

    @data_honest_broker_change =
      if changes[:data_honest_broker].present?
        if changes[:data_honest_broker].first == false
          t(:mailers)[:user_permissions_mailer][:data_honest_broker_granted]
        else
          t(:mailers)[:user_permissions_mailer][:data_honest_broker_removed]
        end
      else
        nil
      end

    @lab_honest_broker_added =
      if changes.dig(:group, :added).present?
        changes[:group][:added].map do |group|
          record = Group.find(group)
          record.name
        end
      else
        nil
      end

    @lab_honest_broker_removed =
      if changes.dig(:group, :removed).present?
        changes[:group][:removed].map do |group|
          record = Group.find(group)
          record.name
        end
      else
        nil
      end

    mail(to: @user.email, subject: t(:mailers)[:user_permissions_mailer][:subject])
  end
end
