package com.ysbing.audioshare;

public class Options {
    String socketName;
    String connectCode;
    int bufferMs = 40;
    int preRollMs = 10;
    int readChunkMs = 5;
    boolean lowLatency = true;

    public static Options parse(String... args) {
        Options options = new Options();

        for (String arg : args) {
            int equalIndex = arg.indexOf('=');
            if (equalIndex == -1) {
                throw new IllegalArgumentException("ARGUMENT_FORMAT_INVALID");
            }
            String key = arg.substring(0, equalIndex);
            String value = arg.substring(equalIndex + 1);
            switch (key) {
                case "socketName":
                    options.socketName = value;
                    break;
                case "connectCode":
                    options.connectCode = value;
                    break;
                case "bufferMs":
                    options.bufferMs = bounded(value, 10, 500);
                    break;
                case "preRollMs":
                    options.preRollMs = bounded(value, 0, 250);
                    break;
                case "readChunkMs":
                    options.readChunkMs = bounded(value, 1, 40);
                    break;
                case "lowLatency":
                    if (!value.equals("true") && !value.equals("false")) {
                        throw new IllegalArgumentException("INVALID_LOW_LATENCY");
                    }
                    options.lowLatency = Boolean.parseBoolean(value);
                    break;
                default:
                    break;
            }
        }

        if (options.socketName == null) throw new IllegalArgumentException("SOCKET_NAME_REQUIRED");
        if (options.connectCode == null) throw new IllegalArgumentException("CONNECT_CODE_REQUIRED");
        if (options.preRollMs > options.bufferMs) {
            throw new IllegalArgumentException("PRE_ROLL_EXCEEDS_BUFFER");
        }

        return options;
    }

    private static int bounded(String value, int minimum, int maximum) {
        int parsed = Integer.parseInt(value);
        if (parsed < minimum || parsed > maximum) {
            throw new IllegalArgumentException("AUDIO_OPTION_OUT_OF_RANGE");
        }
        return parsed;
    }
}
