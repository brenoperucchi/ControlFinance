# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

@count = 1
(1..2).each do |i|
  store = Store.create(name: "store #{i}", language:'pt-BR')
  person = store.persons.create(name: "Person #{i}", department:'admin', person_type:'person', active:1)
  person.create_user(email: "admin#{i}@test.com", password: 123123)
  @broker = store.brokers.create(name: "Broker #{i}", department:'user', person_type:'person', active:1, option1: true, option2: true, option3: true, option4: true, option5: true, option6: true, address: 'Address', phone: 'Phone' , company_irs_id: 'company_irs_id')
  @broker.create_user(email: "test#{i}@test.com", password: 123123)
  @broker.user.make_current
  @broker.approve
end
(1..2).each do |i|
  build = Store.find(i).builds.create(name: "Build #{@count}")
  asset = build.assets.create
  asset.file = Rails.root.join("public/images/system/build_image_#{i}.jpg").open
  asset.save!
  @count +=1
  (1..6).each do |i|
    count = (i % 2 == 0) ? 1 : 2
    unit = build.units.create({name: "10#{i}", value: "#{i}50000", size: 55, garage:"#{i}", brokerage:5.5})
    p = unit.proposals.create(negociate: 'negoaciate', value: "#{i}000", broker:Broker.find(count), due_at: Date.today)
  end
  Proposal::STATUS.each_with_index do |s,i|
    proposal = Proposal.find(i+1)
    proposal.due_at = Date.today - 1.days if s[1] == "book"
    proposal.send(s[1])
  end
end
