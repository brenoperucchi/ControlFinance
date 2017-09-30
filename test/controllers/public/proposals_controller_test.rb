require 'test_helper'

class Public::ProposalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @public_proposal = public_proposals(:one)
  end

  test "should get index" do
    get public_proposals_url
    assert_response :success
  end

  test "should get new" do
    get new_public_proposal_url
    assert_response :success
  end

  test "should create public_proposal" do
    assert_difference('Public::Proposal.count') do
      post public_proposals_url, params: { public_proposal: {  } }
    end

    assert_redirected_to public_proposal_url(Public::Proposal.last)
  end

  test "should show public_proposal" do
    get public_proposal_url(@public_proposal)
    assert_response :success
  end

  test "should get edit" do
    get edit_public_proposal_url(@public_proposal)
    assert_response :success
  end

  test "should update public_proposal" do
    patch public_proposal_url(@public_proposal), params: { public_proposal: {  } }
    assert_redirected_to public_proposal_url(@public_proposal)
  end

  test "should destroy public_proposal" do
    assert_difference('Public::Proposal.count', -1) do
      delete public_proposal_url(@public_proposal)
    end

    assert_redirected_to public_proposals_url
  end
end
