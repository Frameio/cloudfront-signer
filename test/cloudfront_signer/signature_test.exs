defmodule CloudfrontSigner.SignatureTest do
  use ExUnit.Case

  @correct_signature """
ToshDrR-FhIhiStqrp8kAEyQ3YGsz-P5Nh9~~lu0m5l4V-qg3K9Pp~pjYCIYR4yC
OmsN2D1JwBSNYh0hv3l0y7Z2-94hvxx----T6hewE9~kwklOgBfpIcik0AywRDmj
1mmMvhN~5xhEOcnIsErhWiZAm9EpfuHGieH850buSS3rFuNT0DF8Drxmigw7FQgK
XqwddmOaUDlGgjfTvW~n6RSvcRrKBb9Ej~Bjb7~wA8w0p8oKfSyCTGdHfEmNrTW8
kkSi5VnIsHs1~PowwtBv2C2emPFASxKIN2j6Tf5U6Y8x4yMkweee1sr7c39No0Nk
qfabb52SQgIKgXIqIqYwsfsUYHafg9LBMpdVlJjOfIXjaLm1G9ePDQOca1ZMXuVE
LxEBY42IvHiOEeyg4fuw7tVH5DQP3vGT7FoT5NykPsZvxMusYDpfboo63SuKYxVe
rj4x6LlTdVVIrzSS-cmTSZ0y2h4Ok5MLzgW-2sD-e5vRro8H8xTwsfyp8V~wa0Em
ypd2C6WAqa19hvBqHpQx~OaClPh8KNKEZyw-kfJJAuDM~CAy4vX5J3V0XGDcgI-R
DZiZUiPXoTqRlssx-G66UMK0axZwtworvTQyJisMSbGjnRaEA9vgwKo5EEqYGaxc
HQTrKY0PC2Wcm0qUFL5QbqRqU1RL5K3DW5bPNSVdWJo_
""" |> String.replace(~r/\s+/, "")

  describe "#signature/2" do
    test "It will compute the correct signature for a policy" do
      policy = %CloudfrontSigner.Policy{resource: "https://cloudfront.domain.com/some/path", expiry: 1527884313}
      distribution = CloudfrontSigner.Distribution.from_config(:cloudfront_signer, CloudfrontSignerTest)
      
      assert CloudfrontSigner.Signature.signature(policy, distribution.private_key) == @correct_signature
    end
  end
end