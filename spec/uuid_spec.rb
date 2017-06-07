describe Orderly::UUID do

  it "self#generate increments the uuid by one" do
    uuid_1 = described_class.generate
    uuid_2 = described_class.generate
    expect(uuid_2[-12..-1].to_i(16) - uuid_1[-12..-1].to_i(16)).to eq(1)
  end

  it "generates unique IDs across the BLOCK_SIZE boundary" do
    upper_bound = Orderly::UUID::BLOCK * 2 + 10
    uuids = (1..upper_bound).map { Orderly::UUID.generate }
    expect(uuids.size).to eq(uuids.uniq.size)
  end
end
