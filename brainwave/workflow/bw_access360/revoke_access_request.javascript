
function withoutRepositoryManager(/*Array*/ candidatesList) {
	if (candidatesList.length == 0) {
		print("no candidates for RepositoryManager role; computing candidates for defaultreviewer role");
		return workflow.executeRole('defaultreviewer');
	}
	return candidatesList;
}
