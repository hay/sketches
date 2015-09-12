class Result {
    String result;
    String[] risks = { "High risk", "Medium risk", "Low risk" };

    Result() {
        result = getRandomString(risks);
    }

    String getRandomString(String[] strings) {
        int index = int(random(strings.length));
        return strings[index];
    }

    String getText() {
        return result;
    }
}