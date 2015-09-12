class Result {
    String result;
    String risk;
    String[] risks = { "High", "Medium", "Low" };
    String[] posneg = { "+", "-" };
    String[] medical = { "Weak back", "Flat feet", "Migraine", "Stress",
        "Shoulder pain", "RSI", "Bad sight", "Low back pains", "Arthritis",
        "Nonunion", "Osteodystrophy", "Preiser disease", "Spondylosis",
        "Kienbock's disease"};
    String[] mental = { "Xenophobia", "Bipolar disorder",
        "Asperger syndrome", "Clinical formulation", "Dissociative disorder",
        "Excoriation disorder", "Fugue state", "Hyperkinetic disorder",
        "Sexual fetishism", "Rumination syndrome", "Pick's disease" };

    Result() {
        risk = getRandomString(risks);

        result = "Summary\n";
        result += "@ Risk assessment\n";
        result += "# " + risk + " risk\n";
        result += "\n";
        result += "@ Cost modifier\n";
        result += "# €" + getRandomString(posneg);
        result += int(random(100, 900)) + "," + int(random(10, 99)) + " per month\n";
        result += "\n";
        result += "@ Medical assessment\n";
        result += "# BMI " + nfc(random(18, 29), 2) + "\n";
        result += "# " + getRandomString(medical) + "\n";
        result += "\n";
        result += "@ Mental assessment\n";
        result += "# " + getRandomString(mental) + "\n";
        result += "\n";
        result += "@ Life expactancy\n";
        result += "# " + getLife() + "\n";
        result += "-----\n";
        result += getDate() + "\n";
        result += "Mediquantic inc.\n";
        result += "All rights reserved.\n";
    }

    String getLife() {
        int life;

        if (risk == "High") {
            life = int(random(400, 1000));
        } else {
            life = int(random(1000, 10000));
        }

        return life + " days, " + life / 365 + " years";
    }

    String getDate() {
        int d = day();
        int m = month();
        int y = year();
        int h = hour();
        String minute = String.valueOf(minute());

        if (minute.length() == 1) {
            minute = "0" + minute;
        }

        return h + ":" + minute + " " + d + "-" + m + "-" + y;
    }

    String getRandomString(String[] strings) {
        int index = int(random(strings.length));
        return strings[index];
    }

    String getRisk() {
        return risk;
    }

    String getText() {
        return result;
    }
}