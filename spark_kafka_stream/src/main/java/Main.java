import org.apache.flink.api.common.functions.MapFunction;
import org.apache.flink.api.java.utils.ParameterTool;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.connectors.kafka.FlinkKafkaConsumer082;
import org.apache.flink.streaming.util.serialization.SimpleStringSchema;

public class Main {

    public static void main(String[] args) throws Exception {
        StreamExecutionEnvironment env =
                StreamExecutionEnvironment.getExecutionEnvironment();

        ParameterTool parameterTool = ParameterTool.fromArgs(args);

        DataStream<String> messageStream = env
                .addSource(new FlinkKafkaConsumer082<>(
                parameterTool.getRequired("topic"),
                new SimpleStringSchema(),
                parameterTool.getProperties()));

//        messageStream.rebalance().map(new MapFunction<String, String>() {
//            private static final long serialVersionUID = -6867736771747690202L;
//
//            @Override
//            public String map(String value) throws Exception {
//                return "Kafka and Flink says: " + value;
//            }
//        }).print();

//        env.execute();

        messageStream
            .rebalance()
            .map (s -> "Kafka and Flink says: " + s)
            .print();

        env.execute();
    }
}
