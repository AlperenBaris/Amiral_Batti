`timescale 1ns / 1ps






module amiral_batti(
    input clk,
    input [15:0] sw,
    input btnC, btnU, btnL, btnR, btnD,
    output reg [15:0] led = 0,
    output reg [6:0] seg = 0,
    output reg [3:0] an = 0
);


// Combinational regs





// Sequential regs
reg  [15:0] led_next = 0;
reg [6:0] seg_next = 0;
reg [3:0] an_next = 0;
reg [2:0] gameState = 0;
reg [2:0] gameState_next = 0;
reg [19:0] displayBuffer = 0;
reg [19:0] displayBuffer_next = 0;
reg [31:0] counter = 0;
reg [3:0] shipCount;
reg [3:0] shipCount_next;
reg [4:0] guessCount;
reg [4:0] guessCount_next;
reg [6:0] segBuf0 = 7'b0111111;
reg [6:0] segBuf0_next = 7'b0111111;
reg [6:0] segBuf1 = 7'b1111001;
reg [6:0] segBuf1_next = 7'b1111001;
reg [6:0] segBuf2 = 7'b0001100;
reg [6:0] segBuf2_next = 7'b0001100;
reg [6:0] segBuf3 = 7'b0111111;
reg [6:0] segBuf3_next = 7'b0111111;
reg turn = 0;
reg turn_next;
reg [4:0] choiceCounter;
reg [4:0] choiceCounter_next;
reg switchController = 0;
reg [15:0] p1Choices;
reg [15:0] p2Choices;
reg [15:0] p1Choices_next;
reg [15:0] p2Choices_next;
reg [15:0] selectedLeds = 16'b0000000000000000;
reg [15:0] selectedLeds_next = 16'b0000000000000000;
reg [3:0] correct1 = 0;
reg [3:0] correct1_next = 0;
reg [3:0] correct2 = 0;
reg [3:0] correct2_next = 0;
reg fail;
reg fail_next;


// Debouncing
wire btnU_state, btnU_down, btnU_up;
wire btnD_state, btnD_down, btnD_up;
wire btnL_state, btnL_down, btnL_up;
wire btnR_state, btnR_down, btnR_up;
wire btnC_state, btnC_down, btnC_up;
wire [15:0] switch_state;
wire [15:0] switch_down;
wire [15:0] switch_up;

PushButton_Debouncer dU(.clk(clk), .PB(btnU), .PB_state(btnU_state), .PB_down(btnU_down), .PB_up(btnU_up));
PushButton_Debouncer dD(.clk(clk), .PB(btnD), .PB_state(btnD_state), .PB_down(btnD_down), .PB_up(btnD_up));
PushButton_Debouncer dL(.clk(clk), .PB(btnL), .PB_state(btnL_state), .PB_down(btnL_down), .PB_up(btnL_up));
PushButton_Debouncer dR(.clk(clk), .PB(btnR), .PB_state(btnR_state), .PB_down(btnR_down), .PB_up(btnR_up));
PushButton_Debouncer dC(.clk(clk), .PB(btnC), .PB_state(btnC_state), .PB_down(btnC_down), .PB_up(btnC_up));
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[0]), .PB_state(switch_state[0]), .PB_down(switch_down[0]), .PB_up(switch_up[0])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[1]), .PB_state(switch_state[1]), .PB_down(switch_down[1]), .PB_up(switch_up[1])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[2]), .PB_state(switch_state[2]), .PB_down(switch_down[2]), .PB_up(switch_up[2])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[3]), .PB_state(switch_state[3]), .PB_down(switch_down[3]), .PB_up(switch_up[3])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[4]), .PB_state(switch_state[4]), .PB_down(switch_down[4]), .PB_up(switch_up[4])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[5]), .PB_state(switch_state[5]), .PB_down(switch_down[5]), .PB_up(switch_up[5])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[6]), .PB_state(switch_state[6]), .PB_down(switch_down[6]), .PB_up(switch_up[6])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[7]), .PB_state(switch_state[7]), .PB_down(switch_down[7]), .PB_up(switch_up[7])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[8]), .PB_state(switch_state[8]), .PB_down(switch_down[8]), .PB_up(switch_up[8])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[9]), .PB_state(switch_state[9]), .PB_down(switch_down[9]), .PB_up(switch_up[9])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[10]),.PB_state(switch_state[10]), .PB_down(switch_down[10]), .PB_up(switch_up[10])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[11]),.PB_state(switch_state[11]), .PB_down(switch_down[11]), .PB_up(switch_up[11])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[12]), .PB_state(switch_state[12]), .PB_down(switch_down[12]), .PB_up(switch_up[12])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[13]), .PB_state(switch_state[13]), .PB_down(switch_down[13]), .PB_up(switch_up[13])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[14]), .PB_state(switch_state[14]), .PB_down(switch_down[14]), .PB_up(switch_up[14])); 
PushButton_Debouncer #(.N(24)) (.clk(clk), .PB(sw[15]), .PB_state(switch_state[15]), .PB_down(switch_down[15]), .PB_up(switch_up[15])); 


wire [6:0] seg0, seg1, seg2, seg3;
Hexadecimalto7SegmentDisplay(displayBuffer[4:0], 1'b0, seg0);
Hexadecimalto7SegmentDisplay(displayBuffer[4:0], 1'b1, seg1);
Hexadecimalto7SegmentDisplay(5'b00000, 1'b1, seg2);
Hexadecimalto7SegmentDisplay(5'b00000, 1'b1, seg3);


always@(posedge clk) //assign next values to the registers
begin
    led <= led_next;
    seg <= seg_next;
    an <= an_next;
    gameState <= gameState_next;
    displayBuffer <= displayBuffer_next;
    counter <= counter + 1;
    shipCount <= shipCount_next;
    guessCount <= guessCount_next;
    segBuf0 <= segBuf0_next;
    segBuf1 <= segBuf1_next;
    segBuf2 <= segBuf2_next;
    segBuf3 <= segBuf3_next;
    turn <= turn_next;
    choiceCounter <= choiceCounter_next;
    p1Choices <= p1Choices_next;
    p2Choices <= p2Choices_next;
    selectedLeds <= selectedLeds_next;
    correct1 <= correct1_next;
    correct2 <= correct2_next;
    fail <= fail_next;

end

integer i;

always@(*) 
begin
    
    led_next = led;
    seg_next = seg;
    an_next = an;
    gameState_next = gameState;
    displayBuffer_next = displayBuffer;
    shipCount_next = shipCount;
    guessCount_next = guessCount;
    segBuf0_next = segBuf0;
    segBuf1_next = segBuf1;
    segBuf2_next = segBuf2;
    segBuf3_next = segBuf3;
    turn_next = turn;
    choiceCounter_next = choiceCounter;
    p1Choices_next = p1Choices;
    p2Choices_next = p2Choices;
    selectedLeds_next = selectedLeds;
    correct1_next = correct1;
    correct2_next = correct2;
    fail_next = fail;
    
    
    
    if (gameState == 0) //Gemi secme asamasinda yapılacaklar
    begin
            if (btnU_down)
            begin
                if(displayBuffer == 12) //Gemi secme hakkı 1 ile 12 arasında değisir.
                begin
                    displayBuffer_next[4:0] = 1; 
                end 
                else
                begin
                    displayBuffer_next[4:0] = displayBuffer[4:0] + 1; //Butona basinca arttirilir
                end    
            end
            else if (btnD_down)
            begin
                if(displayBuffer == 1)
                begin
                    displayBuffer_next[4:0] = 12;
                end
                else
                begin
                    displayBuffer_next[4:0] = displayBuffer[4:0] - 1;
                end      
            end
            else if(btnC_down)
            begin
                shipCount_next = displayBuffer;
                choiceCounter_next = displayBuffer;
                gameState_next = gameState + 1;
                displayBuffer_next = 1;
            end
        end
        else if(gameState == 1) //Kaç tane tahmin yapılabileceği girişinin alındığı aşama
        begin
             if (btnU_down)
            begin
                if(displayBuffer == 14)
                begin
                    displayBuffer_next[4:0] = 1;
                end
                else
                begin
                    displayBuffer_next[4:0] = displayBuffer[4:0] + 1;
                end    
            end
            else if (btnD_down)
            begin
                if(displayBuffer == 1)
                begin
                    displayBuffer_next[4:0] = 14;
                end
                else
                begin
                    displayBuffer_next[4:0] = displayBuffer[4:0] - 1;
                end      
            end
            else if(btnC_down)
            begin
                if(displayBuffer < shipCount) //Gemi miktarından az tahmin hakkı seçilirse fail yazısı çıkar
                begin
                    displayBuffer_next = shipCount;
                    fail_next = 1;
                end
                else
                begin
                    guessCount_next = displayBuffer;
                    gameState_next = gameState + 1;               
                end
            end
        end
        else if(gameState == 2) //Switchlerle gemileri yerleştirme aşaması
        begin
                if(choiceCounter > 0)
                begin
                    for(i = 0; i < 16; i = i + 1)
                    begin
                        if(switch_up[i] && led[i] == 0)
                        begin
                            led_next[i] = 1'b1;
                            choiceCounter_next = choiceCounter - 1;
                        end
                    end
                end
                else
                begin
                    for(i = 0; i < 16; i = i + 1) //Bütün switchlerin kapalı olup olmadığını kontrol eder
                    begin
                        if(sw[i])
                        begin
                            switchController = 1;
                        end
                    end
                    if(switchController == 0) //Tüm switchler kapalıysa 2. oyuncuya geçilir
                    begin
                        turn_next = ~turn;
                        choiceCounter_next = shipCount;
                        led_next = 0;
                        segBuf0_next = 7'b0111111;
                        segBuf1_next = 7'b0100100;
                        segBuf2_next = 7'b0001100;
                        segBuf3_next = 7'b0111111;
                        if(turn == 0)
                        begin
                            p1Choices_next = led;
                        end
                        else
                        begin
                            p2Choices_next = led;
                            gameState_next = gameState + 1;
                            choiceCounter_next = guessCount;
                            segBuf0_next = 7'b0111111;
                            segBuf1_next = 7'b1111001;
                            segBuf2_next = 7'b0001100;
                            segBuf3_next = 7'b0111111;
                        end

                    end
                    else
                    begin
                        switchController = 0;
                    end
                end
        
        end
        else if(gameState == 3) //Gemi patlatma aşaması
        begin
            if(turn == 0) //1. oyuncu gemileri patlatır
            begin
                if((choiceCounter > 0) && (correct1 != shipCount))
                begin
                    for(i = 0; i < 16; i = i + 1)
                    begin
                        if(switch_up[i] && selectedLeds[i] == 0)
                        begin
                            selectedLeds_next[i] = 1;
                            choiceCounter_next = choiceCounter - 1;
                            
                            if(p2Choices[i] == 1)
                            begin
                                led_next[i] = 1; //Gemi diğer oyuncunun seçtiği yer ise led yanar
                                correct1_next = correct1 + 1; 
                            end
                    
                        end
                
                    end
                
                end
                else
                begin
                    for(i = 0; i < 16; i = i + 1) //Tüm switchler kapalı mı kontrolü yapılır
                    begin
                        if(sw[i])
                        begin
                            switchController = 1;
                        end
                    end
                    
                    if(switchController == 0)
                    begin
                        led_next = 0;
                        choiceCounter_next = guessCount;
                        turn_next = ~turn;
                        selectedLeds_next = 0;
                    end
                    else
                    begin
                        switchController = 0;
                    end
                
                end
            end
            else
            begin
                segBuf0_next = 7'b0111111; //-P2- yazdırılır.
                segBuf1_next = 7'b0100100; 
                segBuf2_next = 7'b0001100; 
                segBuf3_next = 7'b0111111; 
                
                if((choiceCounter > 0) && (correct2 != shipCount)) //2. oyuncu için aynı işlemler yapılır
                begin
                    for(i = 0; i < 16; i = i + 1)
                    begin
                        if(switch_up[i] && selectedLeds[i] == 0)
                        begin
                            selectedLeds_next[i] = 1;
                            choiceCounter_next = choiceCounter - 1;
                            
                            if(p1Choices[i] == 1)
                            begin
                                led_next[i] = 1;
                                correct2_next = correct2 + 1;
                            end
                    
                        end
                
                    end
                
                end
                else
                begin
                    for(i = 0; i < 16; i = i + 1) //Tüm switchler kapalı mı kontrolü yapılır.
                    begin
                        if(sw[i])
                        begin
                            switchController = 1;
                        end
                    end
                    
                    if(switchController == 0)
                    begin
                        led_next = 0;
                        gameState_next = gameState + 1;
                    end
                    else
                    begin
                        switchController = 0;
                    end
                
                end
            
            end
            
        end
        else if(gameState == 4) //Oyunun sonucunun belirlendiği durum
        begin
            if(correct1 > correct2) //1. oyuncunun kazandığı durum
            begin
                segBuf0_next = 7'b0111111; //-P1-
                segBuf1_next = 7'b1111001;
                segBuf2_next = 7'b0001100;
                segBuf3_next = 7'b0111111;
                
                if(counter % 2000000 == 0) //Led soldan sağa kaydırılır.
                begin
                    if(led == 0)
                    begin
                        led_next = 16'b1000000000000000;
                    end
                    else
                    begin
                        led_next = led >> 1;
                    end
                end
            end
            else if(correct2 > correct1) //2. oyuncunun kazandığı durum
            begin
                segBuf0_next = 7'b0111111; //-P2- yazdırılır.
                segBuf1_next = 7'b0100100;
                segBuf2_next = 7'b0001100;
                segBuf3_next = 7'b0111111;
                
                if(counter % 2000000 == 0) 
                begin
                    if(led == 0)
                    begin
                        led_next = 16'b0000000000000001; //Ledler sağdan sola doğru kayadırılır
                    end
                    else
                    begin
                        led_next = led << 1;
                    end
                end
            end
            else //Beraberlik durumu
            begin
                segBuf0_next = 7'b0111111; //---- yazdırılır 
                segBuf1_next = 7'b0111111;
                segBuf2_next = 7'b0111111;
                segBuf3_next = 7'b0111111;
                
                if(counter % 10000000 == 0) //Ledlerin hepsini kapatıp açar
                begin
                    led_next = ~led;
                end
            end
        
        end
    
    if(counter[15:0] < 16'b010000000000000) begin //Digit 0'ı kontrol eder
                if((gameState > 1 && gameState < 4) && turn == 0)
                begin
                    an_next = 4'b1110;
                    seg_next = segBuf0;
                end
                else if((gameState > 1 && gameState < 4) && turn == 1)
                begin
                    an_next = 4'b1110; 
                    seg_next = segBuf0;
                end
                else if(gameState == 4)
                begin
                    seg_next = segBuf0;
                    an_next = 4'b1110;            
                end
                else
                begin
                    an_next = 4'b1110;
                    
                    if(fail == 1)
                    begin
                        seg_next = 7'b1000111; //FAIL yazdırılır. (L harfi)
                        if(counter % 180000000 == 0)
                        begin
                            fail_next = 0;
                        end
                    end
                    else
                    begin
                        seg_next = seg0;   
                    end 
                end
    end
     else if(counter[15:0] < 16'b1000000000000000) begin //Digit 1 kontrol edilir.
             if((gameState > 1) && turn == 0)
                begin
                    an_next = 4'b1101;
                    seg_next = segBuf1;
                end
                else if((gameState > 1) && turn == 1)
                begin
                    an_next = 4'b1101; 
                    seg_next = segBuf1;
                end
                else
                begin
                    an_next = 4'b1101;
                    if(fail == 1)
                    begin
                        seg_next = 7'b1111001; //FAIL yazdırılır. (I harfi)
                        if(counter % 180000000 == 0)
                        begin
                            fail_next = 0;
                        end
                    end
                    else
                    begin
                        seg_next = seg1;   
                    end
                end
            
    end else if(counter[15:0] < 16'b1100000000000000) begin //Digit 2 kontrol edilir.
            if((gameState > 1) && turn == 0)
                begin
                    an_next = 4'b1011;
                    seg_next = segBuf2;
                end
                else if((gameState > 1) && turn == 1)
                begin
                    an_next = 4'b1011;
                    seg_next = segBuf2;
                end
                else
                begin
                    an_next = 4'b1011;
                    if(fail == 1)
                    begin
                        seg_next = 7'b0001000; //FAIL yazdırılır. (A harfi)
                        if(counter % 180000000 == 0)
                        begin
                            fail_next = 0;
                        end
                    end
                    else
                    begin
                        seg_next = seg2;   
                    end
                end
                       
    end else begin //Digit 3 kontrol edilir
            if((gameState > 1) && turn == 0)
                begin
                    an_next = 4'b0111;
                    seg_next = segBuf3;
                end
                else if((gameState > 1) && turn == 1)
                begin
                    an_next = 4'b0111;
                    seg_next = segBuf3;
                end
                else
                begin
                    an_next = 4'b0111;
                    if(fail == 1)
                    begin
                        seg_next = 7'b0001110; //FAIL yazdırılır (F harfi)
                        if(counter % 180000000 == 0)
                        begin
                            fail_next = 0;
                        end
                    end
                    else
                    begin
                        seg_next = seg3;   
                    end
                end
            
    end


end

endmodule


module Hexadecimalto7SegmentDisplay(input [4:0] hex, input segment, output reg [6:0] disp); //Display buffer'dan gelen değere göre seven segmentte gösterilecek sayı gösterilir.
    always @(*) begin
        case(hex)
            4'd0: disp <= 7'b1000000;
            4'd1: begin
                if(segment == 0)
                begin
                    disp <= 7'b1111001;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd2: begin
                if(segment == 0)
                begin
                    disp <= 7'b0100100;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd3: begin
                if(segment == 0)
                begin
                    disp <= 7'b0110000;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd4: begin
                if(segment == 0)
                begin
                    disp <= 7'b0011001;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end 
            4'd5: begin
                if(segment == 0)
                begin
                    disp <= 7'b0010010;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd6: begin
                if(segment == 0)
                begin
                    disp <= 7'b0000010;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd7: begin
                if(segment == 0)
                begin
                    disp <= 7'b1111000;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd8: begin
                if(segment == 0)
                begin
                    disp <= 7'b0000000;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd9: begin
                if(segment == 0)
                begin
                    disp <= 7'b0010000;
                end
                else
                begin
                    disp <= 7'b1000000;
                end
            end
            4'd10: begin
                if (segment == 0)
                begin
                    disp <= 7'b1000000;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            
            end
            4'd11: disp <= 7'b1111001;
            4'd12: begin
                if (segment == 0)
                begin
                    disp <= 7'b0100100;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            
            end
            4'd13: begin
                if (segment == 0)
                begin
                    disp <= 7'b0110000;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            
            end
            4'd14: begin
                if (segment == 0)
                begin
                    disp <= 7'b0011001;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            
            end
            4'd15: begin
                if (segment == 0)
                begin
                    disp <= 7'b0010010;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            
            end
            5'd16: begin
                if (segment == 0)
                begin
                    disp <= 7'b0000010;
                end
                else
                begin
                    disp <= 7'b1111001;
                end
            end
        endcase
    end
endmodule




//BUTTON DEBOUNCERLAR
//Button debouncer module
//Source: https://www.fpga4fun.com/Debouncer2.html
module PushButton_Debouncer #(parameter N = 20)(
    input clk,
    input PB,  // "PB" is the glitchy, asynchronous to clk, active low push-button signal

    // from which we make three outputs, all synchronous to the clock
    output reg PB_state,  // 1 as long as the push-button is active (down)
    output PB_down,  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)
    output PB_up   // 1 for one clock cycle when the push-button goes up (i.e. just released)
);

// First use two flip-flops to synchronize the PB signal the "clk" clock domain
reg PB_sync_0;  always @(posedge clk) PB_sync_0 <= ~PB;  // invert PB to make PB_sync_0 active high
reg PB_sync_1;  always @(posedge clk) PB_sync_1 <= PB_sync_0;

// Next declare a 20-bits counter (~10ms with 100Mhz clock)
reg [N-1:0] PB_cnt;

// When the push-button is pushed or released, we increment the counter
// The counter has to be maxed out before we decide that the push-button state has changed

wire PB_idle = (PB_state==PB_sync_1);
wire PB_cnt_max = &PB_cnt;	// true when all bits of PB_cnt are 1's

always @(posedge clk)
    if(PB_idle)
        PB_cnt <= 0;  // nothing's going on
    else begin
        PB_cnt <= PB_cnt + 1;  // something's going on, increment the counter
        if(PB_cnt_max) PB_state <= ~PB_state;  // if the counter is maxed out, PB changed!
    end

    assign PB_down = ~PB_idle & PB_cnt_max & ~PB_state;
    assign PB_up   = ~PB_idle & PB_cnt_max &  PB_state;
endmodule