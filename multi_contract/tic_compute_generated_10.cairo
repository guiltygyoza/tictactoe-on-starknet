%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.storage import Storage
from starkware.cairo.common.math_cmp import is_not_zero

### THIS CONTRACT IS GENERATED BY GUILTYGYOZA'S SCRIPT ###

func is_zero {range_check_ptr} (value) -> (res):
    # invert the result of is_not_zero()
    let (temp) = is_not_zero(value)
    if temp == 0:
        return (res=1)
    end

    return (res=0)
end

@view
func compute{
        syscall_ptr : felt*,
        storage_ptr : Storage*,
        range_check_ptr
    }(
        a : felt,
        s : felt
    ) -> (
        result : felt
    ):
    alloc_locals

    let (local bool_2820) = is_zero( (a-8) + (s-2120) )
    let (local bool_2821) = is_zero( (a-8) + (s-11400) )
    let (local bool_2822) = is_zero( (a-8) + (s-28440) )
    let (local bool_2823) = is_zero( (a-8) + (s-4950) )
    let (local bool_2824) = is_zero( (a-8) + (s-5020) )
    let (local bool_2825) = is_zero( (a-8) + (s-28510) )
    let (local bool_2826) = is_zero( (a-8) + (s-5130) )
    let (local bool_2827) = is_zero( (a-8) + (s-40790) )
    let (local bool_2828) = is_zero( (a-8) + (s-45630) )
    let (local bool_2829) = is_zero( (a-8) + (s-16580) )
    let (local bool_2830) = is_zero( (a-8) + (s-9200) )
    let (local bool_2831) = is_zero( (a-8) + (s-15500) )
    let (local bool_2832) = is_zero( (a-8) + (s-2190) )
    let (local bool_2833) = is_zero( (a-8) + (s-16360) )
    let (local bool_2834) = is_zero( (a-8) + (s-180) )
    let (local bool_2835) = is_zero( (a-8) + (s-43740) )
    let (local bool_2836) = is_zero( (a-8) + (s-44570) )
    let (local bool_2837) = is_zero( (a-8) + (s-47540) )
    let (local bool_2838) = is_zero( (a-8) + (s-47690) )
    let (local bool_2839) = is_zero( (a-8) + (s-450) )
    let (local bool_2840) = is_zero( (a-8) + (s-6120) )
    let (local bool_2841) = is_zero( (a-8) + (s-28620) )
    let (local bool_2842) = is_zero( (a-8) + (s-43290) )
    let (local bool_2843) = is_zero( (a-8) + (s-43360) )
    let (local bool_2844) = is_zero( (a-8) + (s-6510) )
    let (local bool_2845) = is_zero( (a-8) + (s-45720) )
    let (local bool_2846) = is_zero( (a-8) + (s-45770) )
    let (local bool_2847) = is_zero( (a-8) + (s-1370) )
    let (local bool_2848) = is_zero( (a-8) + (s-16500) )
    let (local bool_2849) = is_zero( (a-8) + (s-14590) )
    let (local bool_2850) = is_zero( (a-8) + (s-14800) )
    let (local bool_2851) = is_zero( (a-8) + (s-15410) )
    let (local bool_2852) = is_zero( (a-8) + (s-31510) )
    let (local bool_2853) = is_zero( (a-8) + (s-70) )
    let (local bool_2854) = is_zero( (a-8) + (s-23560) )
    let (local bool_2855) = is_zero( (a-8) + (s-38210) )
    let (local bool_2856) = is_zero( (a-8) + (s-43340) )
    let (local bool_2857) = is_zero( (a-8) + (s-22760) )
    let (local bool_2858) = is_zero( (a-8) + (s-30800) )
    let (local bool_2859) = is_zero( (a-8) + (s-49730) )
    let (local bool_2860) = is_zero( (a-8) + (s-23640) )
    let (local bool_2861) = is_zero( (a-8) + (s-11690) )
    let (local bool_2862) = is_zero( (a-8) + (s-37430) )
    let (local bool_2863) = is_zero( (a-8) + (s-42560) )
    let (local bool_2864) = is_zero( (a-8) + (s-9140) )
    let (local bool_2865) = is_zero( (a-8) + (s-1840) )
    let (local bool_2866) = is_zero( (a-8) + (s-31530) )
    let (local bool_2867) = is_zero( (a-8) + (s-150) )
    let (local bool_2868) = is_zero( (a-8) + (s-2040) )
    let (local bool_2869) = is_zero( (a-8) + (s-38490) )
    let (local bool_2870) = is_zero( (a-8) + (s-12110) )
    let (local bool_2871) = is_zero( (a-8) + (s-16230) )
    let (local bool_2872) = is_zero( (a-8) + (s-14220) )
    let (local bool_2873) = is_zero( (a-8) + (s-890) )
    let (local bool_2874) = is_zero( (a-8) + (s-5690) )
    let (local bool_2875) = is_zero( (a-8) + (s-2170) )
    let (local bool_2876) = is_zero( (a-8) + (s-2250) )
    let (local bool_2877) = is_zero( (a-8) + (s-2630) )
    let (local bool_2878) = is_zero( (a-8) + (s-39080) )
    let (local bool_2879) = is_zero( (a-8) + (s-24030) )
    let (local bool_2880) = is_zero( (a-8) + (s-8970) )
    let (local bool_2881) = is_zero( (a-8) + (s-1010) )
    let (local bool_2882) = is_zero( (a-8) + (s-21340) )
    let (local bool_2883) = is_zero( (a-8) + (s-1730) )
    let (local bool_2884) = is_zero( (a-8) + (s-9670) )
    let (local bool_2885) = is_zero( (a-8) + (s-6570) )
    let (local bool_2886) = is_zero( (a-8) + (s-11360) )
    let (local bool_2887) = is_zero( (a-8) + (s-30960) )
    let (local bool_2888) = is_zero( (a-8) + (s-110) )
    let (local bool_2889) = is_zero( (a-8) + (s-13980) )
    let (local bool_2890) = is_zero( (a-8) + (s-21890) )
    let (local bool_2891) = is_zero( (a-8) + (s-6750) )
    let (local bool_2892) = is_zero( (a-8) + (s-14060) )
    let (local bool_2893) = is_zero( (a-8) + (s-35990) )
    let (local bool_2894) = is_zero( (a-8) + (s-57200) )
    let (local bool_2895) = is_zero( (a-8) + (s-1830) )
    let (local bool_2896) = is_zero( (a-8) + (s-16620) )
    let (local bool_2897) = is_zero( (a-8) + (s-38230) )
    let (local bool_2898) = is_zero( (a-8) + (s-45390) )
    let (local bool_2899) = is_zero( (a-8) + (s-45580) )
    let (local bool_2900) = is_zero( (a-8) + (s-36900) )
    let (local bool_2901) = is_zero( (a-8) + (s-13430) )
    let (local bool_2902) = is_zero( (a-8) + (s-46170) )
    let (local bool_2903) = is_zero( (a-8) + (s-55080) )
    let (local bool_2904) = is_zero( (a-8) + (s-55290) )
    let (local bool_2905) = is_zero( (a-8) + (s-55580) )
    let (local bool_2906) = is_zero( (a-8) + (s-16840) )
    let (local bool_2907) = is_zero( (a-8) + (s-11810) )
    let (local bool_2908) = is_zero( (a-8) + (s-52860) )
    let (local bool_2909) = is_zero( (a-8) + (s-53150) )
    let (local bool_2910) = is_zero( (a-8) + (s-59270) )
    let (local bool_2911) = is_zero( (a-8) + (s-12070) )
    let (local bool_2912) = is_zero( (a-8) + (s-2970) )
    let (local bool_2913) = is_zero( (a-8) + (s-4600) )
    let (local bool_2914) = is_zero( (a-8) + (s-4810) )
    let (local bool_2915) = is_zero( (a-8) + (s-290) )
    let (local bool_2916) = is_zero( (a-8) + (s-61670) )
    let (local bool_2917) = is_zero( (a-8) + (s-38070) )
    let (local bool_2918) = is_zero( (a-8) + (s-870) )
    let (local bool_2919) = is_zero( (a-8) + (s-3840) )
    let (local bool_2920) = is_zero( (a-8) + (s-47800) )
    let (local bool_2921) = is_zero( (a-8) + (s-48010) )
    let (local bool_2922) = is_zero( (a-8) + (s-38710) )
    let (local bool_2923) = is_zero( (a-8) + (s-1810) )
    let (local bool_2924) = is_zero( (a-8) + (s-4300) )
    let (local bool_2925) = is_zero( (a-8) + (s-15440) )
    let (local bool_2926) = is_zero( (a-8) + (s-59450) )
    let (local bool_2927) = is_zero( (a-8) + (s-14670) )
    let (local bool_2928) = is_zero( (a-8) + (s-43830) )
    let (local bool_2929) = is_zero( (a-8) + (s-38100) )
    let (local bool_2930) = is_zero( (a-8) + (s-1770) )
    let (local bool_2931) = is_zero( (a-8) + (s-11880) )
    let (local bool_2932) = is_zero( (a-8) + (s-23660) )
    let (local bool_2933) = is_zero( (a-8) + (s-7830) )
    let (local bool_2934) = is_zero( (a-8) + (s-8820) )
    let (local bool_2935) = is_zero( (a-8) + (s-11270) )
    let (local bool_2936) = is_zero( (a-8) + (s-38770) )
    let (local bool_2937) = is_zero( (a-8) + (s-46280) )
    let (local bool_2938) = is_zero( (a-8) + (s-48170) )
    let (local bool_2939) = is_zero( (a-8) + (s-51030) )
    let (local bool_2940) = is_zero( (a-8) + (s-15390) )
    let (local bool_2941) = is_zero( (a-8) + (s-20520) )
    let (local bool_2942) = is_zero( (a-8) + (s-64290) )
    let (local bool_2943) = is_zero( (a-8) + (s-20630) )
    let (local bool_2944) = is_zero( (a-8) + (s-4660) )
    let (local bool_2945) = is_zero( (a-8) + (s-4230) )
    let (local bool_2946) = is_zero( (a-8) + (s-27620) )
    let (local bool_2947) = is_zero( (a-8) + (s-48060) )
    let (local bool_2948) = is_zero( (a-8) + (s-9020) )
    let (local bool_2949) = is_zero( (a-8) + (s-9540) )
    let (local bool_2950) = is_zero( (a-8) + (s-12150) )
    let (local bool_2951) = is_zero( (a-8) + (s-13140) )
    let (local bool_2952) = is_zero( (a-8) + (s-9660) )
    let (local bool_2953) = is_zero( (a-8) + (s-4110) )
    let (local bool_2954) = is_zero( (a-8) + (s-2070) )
    let (local bool_2955) = is_zero( (a-8) + (s-1950) )
    let (local bool_2956) = is_zero( (a-8) + (s-38400) )
    let (local bool_2957) = is_zero( (a-8) + (s-13860) )
    let (local bool_2958) = is_zero( (a-8) + (s-5900) )
    let (local bool_2959) = is_zero( (a-8) + (s-56930) )
    let (local bool_2960) = is_zero( (a-8) + (s-9060) )
    let (local bool_2961) = is_zero( (a-8) + (s-1690) )
    let (local bool_2962) = is_zero( (a-8) + (s-45370) )
    let (local bool_2963) = is_zero( (a-8) + (s-4200) )
    let (local bool_2964) = is_zero( (a-8) + (s-31320) )
    let (local bool_2965) = is_zero( (a-8) + (s-630) )
    let (local bool_2966) = is_zero( (a-8) + (s-680) )
    let (local bool_2967) = is_zero( (a-8) + (s-9590) )
    let (local bool_2968) = is_zero( (a-8) + (s-170) )
    let (local bool_2969) = is_zero( (a-8) + (s-9450) )
    let (local bool_2970) = is_zero( (a-8) + (s-14740) )
    let (local bool_2971) = is_zero( (a-8) + (s-55710) )
    let (local bool_2972) = is_zero( (a-8) + (s-45680) )
    let (local bool_2973) = is_zero( (a-8) + (s-24080) )
    let (local bool_2974) = is_zero( (a-8) + (s-26690) )
    let (local bool_2975) = is_zero( (a-8) + (s-4400) )
    let (local bool_2976) = is_zero( (a-8) + (s-23600) )
    let (local bool_2977) = is_zero( (a-8) + (s-57610) )
    let (local bool_2978) = is_zero( (a-8) + (s-28420) )
    let (local bool_2979) = is_zero( (a-8) + (s-9350) )
    let (local bool_2980) = is_zero( (a-8) + (s-64400) )
    let (local bool_2981) = is_zero( (a-8) + (s-20340) )
    let (local bool_2982) = is_zero( (a-8) + (s-20390) )
    let (local bool_2983) = is_zero( (a-8) + (s-47980) )
    let (local bool_2984) = is_zero( (a-8) + (s-4590) )
    let (local bool_2985) = is_zero( (a-8) + (s-48960) )
    let (local bool_2986) = is_zero( (a-8) + (s-16020) )
    let (local bool_2987) = is_zero( (a-8) + (s-2000) )
    let (local bool_2988) = is_zero( (a-8) + (s-60220) )
    let (local bool_2989) = is_zero( (a-8) + (s-28800) )
    let (local bool_2990) = is_zero( (a-8) + (s-36510) )
    let (local bool_2991) = is_zero( (a-8) + (s-19870) )
    let (local bool_2992) = is_zero( (a-8) + (s-47520) )
    let (local bool_2993) = is_zero( (a-8) + (s-24120) )
    let (local bool_2994) = is_zero( (a-8) + (s-45820) )
    let (local bool_2995) = is_zero( (a-8) + (s-13770) )
    let (local bool_2996) = is_zero( (a-8) + (s-14150) )
    let (local bool_2997) = is_zero( (a-8) + (s-16470) )
    let (local bool_2998) = is_zero( (a-8) + (s-4870) )
    let (local bool_2999) = is_zero( (a-8) + (s-28360) )
    let (local bool_3000) = is_zero( (a-8) + (s-700) )
    let (local bool_3001) = is_zero( (a-8) + (s-24190) )
    let (local bool_3002) = is_zero( (a-8) + (s-41200) )
    let (local bool_3003) = is_zero( (a-8) + (s-2100) )
    let (local bool_3004) = is_zero( (a-8) + (s-21930) )
    let (local bool_3005) = is_zero( (a-8) + (s-21490) )
    let (local bool_3006) = is_zero( (a-8) + (s-12060) )
    let (local bool_3007) = is_zero( (a-8) + (s-53410) )
    let (local bool_3008) = is_zero( (a-8) + (s-550) )
    let (local bool_3009) = is_zero( (a-8) + (s-24040) )
    let (local bool_3010) = is_zero( (a-8) + (s-7350) )
    let (local bool_3011) = is_zero( (a-8) + (s-7640) )
    let (local bool_3012) = is_zero( (a-8) + (s-7470) )
    let (local bool_3013) = is_zero( (a-8) + (s-7760) )
    let (local bool_3014) = is_zero( (a-8) + (s-52700) )
    let (local bool_3015) = is_zero( (a-8) + (s-7310) )
    let (local bool_3016) = is_zero( (a-8) + (s-13990) )
    let (local bool_3017) = is_zero( (a-8) + (s-9480) )
    let (local bool_3018) = is_zero( (a-8) + (s-4160) )
    let (local bool_3019) = is_zero( (a-8) + (s-20540) )
    let (local bool_3020) = is_zero( (a-8) + (s-11580) )
    let (local bool_3021) = is_zero( (a-8) + (s-6760) )
    let (local bool_3022) = is_zero( (a-8) + (s-43210) )
    let (local bool_3023) = is_zero( (a-8) + (s-190) )
    let (local bool_3024) = is_zero( (a-8) + (s-25730) )
    let (local bool_3025) = is_zero( (a-8) + (s-45740) )
    let (local bool_3026) = is_zero( (a-8) + (s-65170) )
    let (local bool_3027) = is_zero( (a-8) + (s-570) )
    let (local bool_3028) = is_zero( (a-8) + (s-45120) )
    let (local bool_3029) = is_zero( (a-8) + (s-62130) )
    let (local bool_3030) = is_zero( (a-8) + (s-57630) )
    let (local bool_3031) = is_zero( (a-8) + (s-8960) )
    let (local bool_3032) = is_zero( (a-8) + (s-12030) )
    let (local bool_3033) = is_zero( (a-8) + (s-51580) )
    let (local bool_3034) = is_zero( (a-8) + (s-55630) )
    let (local bool_3035) = is_zero( (a-8) + (s-55840) )
    let (local bool_3036) = is_zero( (a-8) + (s-23670) )
    let (local bool_3037) = is_zero( (a-8) + (s-31470) )
    let (local bool_3038) = is_zero( (a-8) + (s-14870) )
    let (local bool_3039) = is_zero( (a-8) + (s-18720) )
    let (local bool_3040) = is_zero( (a-8) + (s-21420) )
    let (local bool_3041) = is_zero( (a-8) + (s-43310) )
    let (local bool_3042) = is_zero( (a-8) + (s-59220) )
    let (local bool_3043) = is_zero( (a-8) + (s-9100) )
    let (local bool_3044) = is_zero( (a-8) + (s-45400) )
    let (local bool_3045) = is_zero( (a-8) + (s-7900) )
    let (local bool_3046) = is_zero( (a-8) + (s-54070) )
    let (local bool_3047) = is_zero( (a-8) + (s-23680) )
    let (local bool_3048) = is_zero( (a-8) + (s-16300) )
    let (local bool_3049) = is_zero( (a-8) + (s-50260) )
    let (local bool_3050) = is_zero( (a-8) + (s-47570) )
    let (local bool_3051) = is_zero( (a-8) + (s-6820) )
    let (local bool_3052) = is_zero( (a-8) + (s-8020) )
    let (local bool_3053) = is_zero( (a-8) + (s-12910) )
    let (local bool_3054) = is_zero( (a-8) + (s-57870) )
    let (local bool_3055) = is_zero( (a-8) + (s-43750) )
    let (local bool_3056) = is_zero( (a-8) + (s-51180) )
    let (local bool_3057) = is_zero( (a-8) + (s-55270) )
    let (local bool_3058) = is_zero( (a-8) + (s-59240) )
    let (local bool_3059) = is_zero( (a-8) + (s-57730) )
    let (local bool_3060) = is_zero( (a-8) + (s-6840) )
    let (local bool_3061) = is_zero( (a-8) + (s-50520) )
    let (local bool_3062) = is_zero( (a-8) + (s-65110) )
    let (local bool_3063) = is_zero( (a-8) + (s-46800) )
    let (local bool_3064) = is_zero( (a-8) + (s-51320) )
    let (local bool_3065) = is_zero( (a-8) + (s-55370) )
    let (local bool_3066) = is_zero( (a-8) + (s-5000) )
    let (local bool_3067) = is_zero( (a-8) + (s-13910) )
    let (local bool_3068) = is_zero( (a-8) + (s-3320) )
    let (local bool_3069) = is_zero( (a-8) + (s-30980) )
    let (local bool_3070) = is_zero( (a-8) + (s-45100) )
    let (local bool_3071) = is_zero( (a-8) + (s-60040) )
    let (local bool_3072) = is_zero( (a-8) + (s-64310) )
    let (local bool_3073) = is_zero( (a-8) + (s-7890) )
    let (local bool_3074) = is_zero( (a-8) + (s-11940) )
    let (local bool_3075) = is_zero( (a-8) + (s-14190) )
    let (local bool_3076) = is_zero( (a-8) + (s-43880) )
    let (local bool_3077) = is_zero( (a-8) + (s-11950) )
    let (local bool_3078) = is_zero( (a-8) + (s-52680) )
    let (local bool_3079) = is_zero( (a-8) + (s-52970) )
    let (local bool_3080) = is_zero( (a-8) + (s-47790) )
    let (local bool_3081) = is_zero( (a-8) + (s-55310) )
    let (local bool_3082) = is_zero( (a-8) + (s-18630) )
    let (local bool_3083) = is_zero( (a-8) + (s-48000) )
    let (local bool_3084) = is_zero( (a-8) + (s-48340) )
    let (local bool_3085) = is_zero( (a-8) + (s-44840) )
    let (local bool_3086) = is_zero( (a-8) + (s-52310) )
    let (local bool_3087) = is_zero( (a-8) + (s-18740) )
    let (local bool_3088) = is_zero( (a-8) + (s-60300) )
    let (local bool_3089) = is_zero( (a-8) + (s-36450) )
    let (local bool_3090) = is_zero( (a-8) + (s-40500) )
    let (local bool_3091) = is_zero( (a-8) + (s-1050) )
    let (local bool_3092) = is_zero( (a-8) + (s-210) )
    let (local bool_3093) = is_zero( (a-8) + (s-13800) )
    let (local bool_3094) = is_zero( (a-8) + (s-43030) )
    let (local bool_3095) = is_zero( (a-8) + (s-5310) )
    let (local bool_3096) = is_zero( (a-8) + (s-24180) )
    let (local bool_3097) = is_zero( (a-8) + (s-52920) )
    let (local bool_3098) = is_zero( (a-8) + (s-12700) )
    let (local bool_3099) = is_zero( (a-8) + (s-15150) )
    let (local bool_3100) = is_zero( (a-8) + (s-37280) )
    let (local bool_3101) = is_zero( (a-8) + (s-4120) )
    let (local bool_3102) = is_zero( (a-8) + (s-58350) )
    let (local bool_3103) = is_zero( (a-8) + (s-51210) )
    let (local bool_3104) = is_zero( (a-8) + (s-43900) )
    let (local bool_3105) = is_zero( (a-8) + (s-4800) )
    let (local bool_3106) = is_zero( (a-8) + (s-760) )
    let (local bool_3107) = is_zero( (a-8) + (s-24250) )
    let (local bool_3108) = is_zero( (a-8) + (s-38140) )
    let (local bool_3109) = is_zero( (a-8) + (s-8840) )
    tempvar sop = bool_2820 * 49 + bool_2821 * 99 + bool_2822 * 99 + bool_2823 * 99 + bool_2824 * 99 + bool_2825 * 49 + bool_2826 * 99 + bool_2827 * 99 + bool_2828 * 49 + bool_2829 * 99 + bool_2830 * 99 + bool_2831 * 49 + bool_2832 * 99 + bool_2833 * 62 + bool_2834 * 99 + bool_2835 * 99 + bool_2836 * 99 + bool_2837 * 99 + bool_2838 * 149 + bool_2839 * 99 + bool_2840 * 99 + bool_2841 * 99 + bool_2842 * 99 + bool_2843 * 99 + bool_2844 * 99 + bool_2845 * 99 + bool_2846 * 99 + bool_2847 * 49 + bool_2848 * 99 + bool_2849 * 175 + bool_2850 * 99 + bool_2851 * 49 + bool_2852 * 99 + bool_2853 * 99 + bool_2854 * 99 + bool_2855 * 49 + bool_2856 * 99 + bool_2857 * 49 + bool_2858 * 149 + bool_2859 * 99 + bool_2860 * 99 + bool_2861 * 49 + bool_2862 * 49 + bool_2863 * 99 + bool_2864 * 100 + bool_2865 * 49 + bool_2866 * 149 + bool_2867 * 99 + bool_2868 * 99 + bool_2869 * 99 + bool_2870 * 99 + bool_2871 * 49 + bool_2872 * 99 + bool_2873 * 99 + bool_2874 * 99 + bool_2875 * 49 + bool_2876 * 99 + bool_2877 * 99 + bool_2878 * 49 + bool_2879 * 99 + bool_2880 * 49 + bool_2881 * 49 + bool_2882 * 49 + bool_2883 * 99 + bool_2884 * 49 + bool_2885 * 99 + bool_2886 * 99 + bool_2887 * 149 + bool_2888 * 99 + bool_2889 * 49 + bool_2890 * 99 + bool_2891 * 99 + bool_2892 * 99 + bool_2893 * 99 + bool_2894 * 99 + bool_2895 * 49 + bool_2896 * 49 + bool_2897 * 99 + bool_2898 * 99 + bool_2899 * 49 + bool_2900 * 99 + bool_2901 * 49 + bool_2902 * 99 + bool_2903 * 99 + bool_2904 * 99 + bool_2905 * 99 + bool_2906 * 49 + bool_2907 * 49 + bool_2908 * 99 + bool_2909 * 99 + bool_2910 * 99 + bool_2911 * 99 + bool_2912 * 99 + bool_2913 * 99 + bool_2914 * 49 + bool_2915 * 99 + bool_2916 * 99 + bool_2917 * 99 + bool_2918 * 99 + bool_2919 * 99 + bool_2920 * 99 + bool_2921 * 99 + bool_2922 * 99 + bool_2923 * 49 + bool_2924 * 99 + bool_2925 * 99 + bool_2926 * 99 + bool_2927 * 99 + bool_2928 * 99 + bool_2929 * 99 + bool_2930 * 99 + bool_2931 * 99 + bool_2932 * 99 + bool_2933 * 99 + bool_2934 * 99 + bool_2935 * 99 + bool_2936 * 99 + bool_2937 * 99 + bool_2938 * 99 + bool_2939 * 99 + bool_2940 * 99 + bool_2941 * 99 + bool_2942 * 99 + bool_2943 * 99 + bool_2944 * 99 + bool_2945 * 99 + bool_2946 * 49 + bool_2947 * 99 + bool_2948 * 167 + bool_2949 * 49 + bool_2950 * 99 + bool_2951 * 99 + bool_2952 * 49 + bool_2953 * 49 + bool_2954 * 49 + bool_2955 * 24 + bool_2956 * 49 + bool_2957 * 49 + bool_2958 * 99 + bool_2959 * 99 + bool_2960 * 49 + bool_2961 * 49 + bool_2962 * 49 + bool_2963 * 99 + bool_2964 * 99 + bool_2965 * 99 + bool_2966 * 99 + bool_2967 * 99 + bool_2968 * 99 + bool_2969 * 49 + bool_2970 * 122 + bool_2971 * 99 + bool_2972 * 99 + bool_2973 * 99 + bool_2974 * 49 + bool_2975 * 99 + bool_2976 * 99 + bool_2977 * 99 + bool_2978 * 49 + bool_2979 * 49 + bool_2980 * 99 + bool_2981 * 99 + bool_2982 * 49 + bool_2983 * 49 + bool_2984 * 99 + bool_2985 * 99 + bool_2986 * 99 + bool_2987 * 99 + bool_2988 * 99 + bool_2989 * 99 + bool_2990 * 99 + bool_2991 * 99 + bool_2992 * 99 + bool_2993 * 49 + bool_2994 * 49 + bool_2995 * 99 + bool_2996 * 99 + bool_2997 * 49 + bool_2998 * 99 + bool_2999 * 99 + bool_3000 * 99 + bool_3001 * 99 + bool_3002 * 149 + bool_3003 * 99 + bool_3004 * 99 + bool_3005 * 49 + bool_3006 * 99 + bool_3007 * 49 + bool_3008 * 99 + bool_3009 * 99 + bool_3010 * 99 + bool_3011 * 99 + bool_3012 * 99 + bool_3013 * 49 + bool_3014 * 99 + bool_3015 * 99 + bool_3016 * 99 + bool_3017 * 49 + bool_3018 * 149 + bool_3019 * 99 + bool_3020 * 99 + bool_3021 * 99 + bool_3022 * 99 + bool_3023 * 99 + bool_3024 * 99 + bool_3025 * 99 + bool_3026 * 99 + bool_3027 * 99 + bool_3028 * 99 + bool_3029 * 99 + bool_3030 * 99 + bool_3031 * 99 + bool_3032 * 174 + bool_3033 * 99 + bool_3034 * 99 + bool_3035 * 99 + bool_3036 * 49 + bool_3037 * 149 + bool_3038 * 99 + bool_3039 * 149 + bool_3040 * 99 + bool_3041 * 99 + bool_3042 * 99 + bool_3043 * 99 + bool_3044 * 99 + bool_3045 * 99 + bool_3046 * 99 + bool_3047 * 99 + bool_3048 * 99 + bool_3049 * 99 + bool_3050 * 99 + bool_3051 * 99 + bool_3052 * 99 + bool_3053 * 49 + bool_3054 * 49 + bool_3055 * 99 + bool_3056 * 99 + bool_3057 * 99 + bool_3058 * 99 + bool_3059 * 49 + bool_3060 * 99 + bool_3061 * 99 + bool_3062 * 49 + bool_3063 * 149 + bool_3064 * 99 + bool_3065 * 99 + bool_3066 * 99 + bool_3067 * 49 + bool_3068 * 99 + bool_3069 * 174 + bool_3070 * 149 + bool_3071 * 99 + bool_3072 * 99 + bool_3073 * 99 + bool_3074 * 99 + bool_3075 * 99 + bool_3076 * 99 + bool_3077 * 99 + bool_3078 * 99 + bool_3079 * 99 + bool_3080 * 99 + bool_3081 * 99 + bool_3082 * 99 + bool_3083 * 49 + bool_3084 * 99 + bool_3085 * 99 + bool_3086 * 49 + bool_3087 * 149 + bool_3088 * 49 + bool_3089 * 99 + bool_3090 * 49 + bool_3091 * 99 + bool_3092 * 99 + bool_3093 * 99 + bool_3094 * 49 + bool_3095 * 99 + bool_3096 * 99 + bool_3097 * 49 + bool_3098 * 99 + bool_3099 * 99 + bool_3100 * 99 + bool_3101 * 49 + bool_3102 * 99 + bool_3103 * 99 + bool_3104 * 49 + bool_3105 * 99 + bool_3106 * 99 + bool_3107 * 99 + bool_3108 * 99 + bool_3109 * 99
    return (result=sop)
end
