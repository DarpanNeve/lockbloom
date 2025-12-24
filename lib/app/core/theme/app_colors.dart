import 'package:flutter/material.dart';

class AppColors {
  /// A curated list of premium accent colors categorized by mood/style.
  static const List<AccentColorOption> accentColors = [
    // -------------------------------------------------------------------------
    // ESSENTIALS (Professional & Clean)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'brand_blue',
      name: 'Bloom Blue',
      nameHi: 'ब्लूम नीला',
      category: 'Essentials',
      primary: Color(0xFF3B82F6),
      primaryLight: Color(0xFF60A5FA),
      primaryDark: Color(0xFF2563EB),
      primaryContainer: Color(0xFFEFF6FF),
      onPrimaryContainer: Color(0xFF1E3A8A),
    ),
    AccentColorOption(
      id: 'brand_teal',
      name: 'Lock Teal',
      nameHi: 'लॉक टील',
      category: 'Essentials',
      primary: Color(0xFF14B8A6),
      primaryLight: Color(0xFF2DD4BF),
      primaryDark: Color(0xFF0D9488),
      primaryContainer: Color(0xFFF0FDFA),
      onPrimaryContainer: Color(0xFF134E4A),
    ),
    AccentColorOption(
      id: 'brand_purple',
      name: 'Sovereign Purple',
      nameHi: 'सॉवरिन बैंगनी',
      category: 'Essentials',
      primary: Color(0xFF8B5CF6),
      primaryLight: Color(0xFFA78BFA),
      primaryDark: Color(0xFF7C3AED),
      primaryContainer: Color(0xFFF5F3FF),
      onPrimaryContainer: Color(0xFF5B21B6),
    ),
    AccentColorOption(
      id: 'brand_indigo',
      name: 'Deep Indigo',
      nameHi: 'गहरा इंडिगो',
      category: 'Essentials',
      primary: Color(0xFF6366F1),
      primaryLight: Color(0xFF818CF8),
      primaryDark: Color(0xFF4F46E5),
      primaryContainer: Color(0xFFEEF2FF),
      onPrimaryContainer: Color(0xFF4338CA),
    ),
    AccentColorOption(
      id: 'classic_navy',
      name: 'Classic Navy',
      nameHi: 'क्लासिक नेवी',
      category: 'Essentials',
      primary: Color(0xFF1E40AF),
      primaryLight: Color(0xFF3B82F6),
      primaryDark: Color(0xFF172554),
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF172554),
    ),
    AccentColorOption(
      id: 'hunter_green',
      name: 'Hunter Green',
      nameHi: 'हंटर ग्रीन',
      category: 'Essentials',
      primary: Color(0xFF15803D),
      primaryLight: Color(0xFF22C55E),
      primaryDark: Color(0xFF14532D),
      primaryContainer: Color(0xFFDCFCE7),
      onPrimaryContainer: Color(0xFF052E16),
    ),
    AccentColorOption(
      id: 'classic_silver',
      name: 'Classic Silver',
      nameHi: 'क्लासिक रजत',
      category: 'Essentials',
      primary: Color(0xFF9CA3AF),
      primaryLight: Color(0xFFD1D5DB),
      primaryDark: Color(0xFF6B7280),
      primaryContainer: Color(0xFFF9FAFB),
      onPrimaryContainer: Color(0xFF111827),
    ),
    AccentColorOption(
      id: 'graphite',
      name: 'Graphite',
      nameHi: 'ग्रेफाइट',
      category: 'Essentials',
      primary: Color(0xFF4B5563),
      primaryLight: Color(0xFF6B7280),
      primaryDark: Color(0xFF374151),
      primaryContainer: Color(0xFFF3F4F6),
      onPrimaryContainer: Color(0xFF1F2937),
    ),

    // -------------------------------------------------------------------------
    // VIBRANT (High Energy & Neon)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'electric_violet',
      name: 'Electric Violet',
      nameHi: 'इलेक्ट्रिक बैंगनी',
      category: 'Vibrant',
      primary: Color(0xFF7C3AED),
      primaryLight: Color(0xFF8B5CF6),
      primaryDark: Color(0xFF6D28D9),
      primaryContainer: Color(0xFFF5F3FF),
      onPrimaryContainer: Color(0xFF4C1D95),
    ),
    AccentColorOption(
      id: 'neon_pink',
      name: 'Neon Pink',
      nameHi: 'नियॉन गुलाबी',
      category: 'Vibrant',
      primary: Color(0xFFFF0080),
      primaryLight: Color(0xFFFF40A0),
      primaryDark: Color(0xFFD10069),
      primaryContainer: Color(0xFFFCE7F3),
      onPrimaryContainer: Color(0xFF9D174D),
    ),
    AccentColorOption(
      id: 'dragon_fruit',
      name: 'Dragon Fruit',
      nameHi: 'ड्रैगन फ्रूट',
      category: 'Vibrant',
      primary: Color(0xFFD946EF),
      primaryLight: Color(0xFFE879F9),
      primaryDark: Color(0xFFA21CAF),
      primaryContainer: Color(0xFFFAE8FF),
      onPrimaryContainer: Color(0xFF701A75),
    ),
    AccentColorOption(
      id: 'cyber_lime',
      name: 'Cyber Lime',
      nameHi: 'साइबर लाइम',
      category: 'Vibrant',
      primary: Color(0xFF84CC16),
      primaryLight: Color(0xFFA3E635),
      primaryDark: Color(0xFF65A30D),
      primaryContainer: Color(0xFFECFCCB),
      onPrimaryContainer: Color(0xFF365314),
    ),
     AccentColorOption(
      id: 'acid_green',
      name: 'Acid Green',
      nameHi: 'एसिड ग्रीन',
      category: 'Vibrant',
      primary: Color(0xFFA3E635),
      primaryLight: Color(0xFFBEF264),
      primaryDark: Color(0xFF65A30D),
      primaryContainer: Color(0xFFF7FEE7),
      onPrimaryContainer: Color(0xFF3F6212),
    ),
    AccentColorOption(
      id: 'blaze_orange',
      name: 'Blaze Orange',
      nameHi: 'ब्लेज़ नारंगी',
      category: 'Vibrant',
      primary: Color(0xFFF97316),
      primaryLight: Color(0xFFFB923C),
      primaryDark: Color(0xFFEA580C),
      primaryContainer: Color(0xFFFFF7ED),
      onPrimaryContainer: Color(0xFF9A3412),
    ),
    AccentColorOption(
      id: 'laser_lemon',
      name: 'Laser Yellow',
      nameHi: 'लेजर पीला',
      category: 'Vibrant',
      primary: Color(0xFFEAB308),
      primaryLight: Color(0xFFFACC15),
      primaryDark: Color(0xFFCA8A04),
      primaryContainer: Color(0xFFFEF9C3),
      onPrimaryContainer: Color(0xFF854D0E),
    ),
     AccentColorOption(
      id: 'hot_coral',
      name: 'Hot Coral',
      nameHi: 'गर्म मूंगा',
      category: 'Vibrant',
      primary: Color(0xFFF43F5E),
      primaryLight: Color(0xFFFB7185),
      primaryDark: Color(0xFFE11D48),
      primaryContainer: Color(0xFFFFF1F2),
      onPrimaryContainer: Color(0xFF881337),
    ),
    AccentColorOption(
      id: 'cyan_pop',
      name: 'Cyan Pop',
      nameHi: 'सियान पॉप',
      category: 'Vibrant',
      primary: Color(0xFF06B6D4),
      primaryLight: Color(0xFF22D3EE),
      primaryDark: Color(0xFF0891B2),
      primaryContainer: Color(0xFFECFEFF),
      onPrimaryContainer: Color(0xFF155E75),
    ),
    AccentColorOption(
      id: 'mediterranean',
      name: 'Mediterranean',
      nameHi: 'भूमध्यसागरीय',
      category: 'Vibrant',
      primary: Color(0xFF0EA5E9),
      primaryLight: Color(0xFF38BDF8),
      primaryDark: Color(0xFF0284C7),
      primaryContainer: Color(0xFFF0F9FF),
      onPrimaryContainer: Color(0xFF0C4A6E),
    ),
    AccentColorOption(
      id: 'radiant_orchid',
      name: 'Radiant Orchid',
      nameHi: 'चमकदार आर्किड',
      category: 'Vibrant',
      primary: Color(0xFFD946EF),
      primaryLight: Color(0xFFF0ABFC),
      primaryDark: Color(0xFFC026D3),
      primaryContainer: Color(0xFFFAE8FF),
      onPrimaryContainer: Color(0xFF701A75),
    ),
    AccentColorOption(
      id: 'cyber_yellow',
      name: 'Cyber Yellow',
      nameHi: 'साइबर पीला',
      category: 'Vibrant',
      primary: Color(0xFFFFD600),
      primaryLight: Color(0xFFFFEA00),
      primaryDark: Color(0xFFFFAB00),
      primaryContainer: Color(0xFFFFFDE7),
      onPrimaryContainer: Color(0xFFF57F17),
    ),
    AccentColorOption(
      id: 'toxic_green',
      name: 'Toxic Green',
      nameHi: 'विषाक्त हरा',
      category: 'Vibrant',
      primary: Color(0xFF76FF03),
      primaryLight: Color(0xFFB0FF57),
      primaryDark: Color(0xFF32CB00),
      primaryContainer: Color(0xFFF1F8E9),
      onPrimaryContainer: Color(0xFF1B5E20),
    ),
     AccentColorOption(
      id: 'blue_lagoon',
      name: 'Blue Lagoon',
      nameHi: 'ब्लू लैगून',
      category: 'Vibrant',
      primary: Color(0xFF00E5FF),
      primaryLight: Color(0xFF84FFFF),
      primaryDark: Color(0xFF00B8D4),
      primaryContainer: Color(0xFFE0F7FA),
      onPrimaryContainer: Color(0xFF006064),
    ),

    // -------------------------------------------------------------------------
    // JEWEL (Rich & Luxurious)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'ruby_red',
      name: 'Ruby Red',
      nameHi: 'रूबि लाल',
      category: 'Jewel',
      primary: Color(0xFF9F1239),
      primaryLight: Color(0xFFBE123C),
      primaryDark: Color(0xFF881337),
      primaryContainer: Color(0xFFFFF1F2),
      onPrimaryContainer: Color(0xFF881337),
    ),
    AccentColorOption(
      id: 'sapphire_blue',
      name: 'Sapphire Blue',
      nameHi: 'नीलम नीला',
      category: 'Jewel',
      primary: Color(0xFF1E3A8A),
      primaryLight: Color(0xFF2563EB),
      primaryDark: Color(0xFF172554),
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF172554),
    ),
    AccentColorOption(
      id: 'emerald_city',
      name: 'Emerald City',
      nameHi: 'पन्ना शहर',
      category: 'Jewel',
      primary: Color(0xFF047857),
      primaryLight: Color(0xFF059669),
      primaryDark: Color(0xFF064E3B),
      primaryContainer: Color(0xFFD1FAE5),
      onPrimaryContainer: Color(0xFF065F46),
    ),
    AccentColorOption(
      id: 'amethyst',
      name: 'Amethyst',
      nameHi: 'एमेथिस्ट',
      category: 'Jewel',
      primary: Color(0xFF7E22CE),
      primaryLight: Color(0xFF9333EA),
      primaryDark: Color(0xFF581C87),
      primaryContainer: Color(0xFFF3E8FF),
      onPrimaryContainer: Color(0xFF581C87),
    ),
    AccentColorOption(
      id: 'topaz',
      name: 'Topaz',
      nameHi: 'पुखराज',
      category: 'Jewel',
      primary: Color(0xFF0F766E),
      primaryLight: Color(0xFF0D9488),
      primaryDark: Color(0xFF115E59),
      primaryContainer: Color(0xFFCCFBF1),
      onPrimaryContainer: Color(0xFF134E4A),
    ),
    AccentColorOption(
      id: 'garnet',
      name: 'Garnet',
      nameHi: 'गार्नेट',
      category: 'Jewel',
      primary: Color(0xFF7F1D1D),
      primaryLight: Color(0xFF991B1B),
      primaryDark: Color(0xFF450A0A),
      primaryContainer: Color(0xFFFEF2F2),
      onPrimaryContainer: Color(0xFF450A0A),
    ),

    // -------------------------------------------------------------------------
    // PASTEL (Soft & Smooth)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'pastel_rose',
      name: 'Dusty Rose',
      nameHi: 'डस्टी रोज़',
      category: 'Pastel',
      primary: Color(0xFFFDA4AF),
      primaryLight: Color(0xFFFECDD3),
      primaryDark: Color(0xFFFB7185),
      primaryContainer: Color(0xFFFFF1F2),
      onPrimaryContainer: Color(0xFF881337),
    ),
    AccentColorOption(
      id: 'lavender_mist',
      name: 'Lavender Mist',
      nameHi: 'लैवेंडर मिस्ट',
      category: 'Pastel',
      primary: Color(0xFFC4B5FD),
      primaryLight: Color(0xFFDDD6FE),
      primaryDark: Color(0xFFA78BFA),
      primaryContainer: Color(0xFFF5F3FF),
      onPrimaryContainer: Color(0xFF4C1D95),
    ),
    AccentColorOption(
      id: 'baby_blue',
      name: 'Baby Blue',
      nameHi: 'बेबी ब्लू',
      category: 'Pastel',
      primary: Color(0xFF93C5FD),
      primaryLight: Color(0xFFBFDBFE),
      primaryDark: Color(0xFF60A5FA),
      primaryContainer: Color(0xFFEFF6FF),
      onPrimaryContainer: Color(0xFF1E3A8A),
    ),
    AccentColorOption(
      id: 'mint_fresh',
      name: 'Fresh Mint',
      nameHi: 'ताजा पुदीना',
      category: 'Pastel',
      primary: Color(0xFF6EE7B7),
      primaryLight: Color(0xFFA7F3D0),
      primaryDark: Color(0xFF34D399),
      primaryContainer: Color(0xFFECFDF5),
      onPrimaryContainer: Color(0xFF065F46),
    ),
    AccentColorOption(
      id: 'pale_mint',
      name: 'Pale Mint',
      nameHi: 'हल्का पुदीना',
      category: 'Pastel',
      primary: Color(0xFFA7F3D0),
      primaryLight: Color(0xFFD1FAE5),
      primaryDark: Color(0xFF6EE7B7),
      primaryContainer: Color(0xFFECFDF5),
      onPrimaryContainer: Color(0xFF065F46),
    ),
    AccentColorOption(
      id: 'peach_fuzz',
      name: 'Peach Fuzz',
      nameHi: 'पीच फ़ज़',
      category: 'Pastel',
      primary: Color(0xFFFDBA74),
      primaryLight: Color(0xFFFED7AA),
      primaryDark: Color(0xFFFB923C),
      primaryContainer: Color(0xFFFFF7ED),
      onPrimaryContainer: Color(0xFF9A3412),
    ),
    AccentColorOption(
      id: 'buttercream',
      name: 'Buttercream',
      nameHi: 'बटऱक्रीम',
      category: 'Pastel',
      primary: Color(0xFFFDE047),
      primaryLight: Color(0xFFFEF08A),
      primaryDark: Color(0xFFFACC15),
      primaryContainer: Color(0xFFFEF9C3),
      onPrimaryContainer: Color(0xFF854D0E),
    ),
    AccentColorOption(
      id: 'sky_light',
      name: 'Cloud Nine',
      nameHi: 'क्लाउड नाइन',
      category: 'Pastel',
      primary: Color(0xFF7DD3FC),
      primaryLight: Color(0xFFBAE6FD),
      primaryDark: Color(0xFF38BDF8),
      primaryContainer: Color(0xFFF0F9FF),
      onPrimaryContainer: Color(0xFF0C4A6E),
    ),
    AccentColorOption(
      id: 'periwinkle_soft',
      name: 'Soft Periwinkle',
      nameHi: 'सॉफ्ट पेरिविंकल',
      category: 'Pastel',
      primary: Color(0xFFA5B4FC),
      primaryLight: Color(0xFFC7D2FE),
      primaryDark: Color(0xFF818CF8),
      primaryContainer: Color(0xFFEEF2FF),
      onPrimaryContainer: Color(0xFF312E81),
    ),
    AccentColorOption(
      id: 'soft_lilac',
      name: 'Soft Lilac',
      nameHi: 'हल्का बकाइन',
      category: 'Pastel',
      primary: Color(0xFFE9D5FF),
      primaryLight: Color(0xFFF3E8FF),
      primaryDark: Color(0xFFD8B4FE),
      primaryContainer: Color(0xFFFAF5FF),
      onPrimaryContainer: Color(0xFF6B21A8),
    ),
    AccentColorOption(
      id: 'creamsicle',
      name: 'Creamsicle',
      nameHi: 'क्रीम्सिकल',
      category: 'Pastel',
      primary: Color(0xFFFFE0B2),
      primaryLight: Color(0xFFFFF3E0),
      primaryDark: Color(0xFFFFCC80),
      primaryContainer: Color(0xFFFFF8E1),
      onPrimaryContainer: Color(0xFFFF6F00),
    ),
    AccentColorOption(
      id: 'foam_green',
      name: 'Foam Green',
      nameHi: 'फोम हरा',
      category: 'Pastel',
      primary: Color(0xFFB9F6CA),
      primaryLight: Color(0xFF69F0AE),
      primaryDark: Color(0xFF00E676),
      primaryContainer: Color(0xFFE0F2F1),
      onPrimaryContainer: Color(0xFF00695C),
    ),
    AccentColorOption(
      id: 'lemon_chiffon',
      name: 'Lemon Chiffon',
      nameHi: 'लेमन शिफॉन',
      category: 'Pastel',
      primary: Color(0xFFFFF59D),
      primaryLight: Color(0xFFFFF9C4),
      primaryDark: Color(0xFFFBC02D),
      primaryContainer: Color(0xFFFFFDE7),
      onPrimaryContainer: Color(0xFFF57F17),
    ),

    // -------------------------------------------------------------------------
    // DEEP (Rich & Elegant)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'midnight_navy',
      name: 'Midnight Navy',
      nameHi: 'मिडनाइट नेवी',
      category: 'Deep',
      primary: Color(0xFF1E3A8A),
      primaryLight: Color(0xFF2563EB),
      primaryDark: Color(0xFF172554),
      primaryContainer: Color(0xFFDBEAFE),
      onPrimaryContainer: Color(0xFF1E3A8A),
    ),
    AccentColorOption(
      id: 'forest_depths',
      name: 'Forest Depths',
      nameHi: 'वन गहराई',
      category: 'Deep',
      primary: Color(0xFF14532D),
      primaryLight: Color(0xFF16A34A),
      primaryDark: Color(0xFF052E16),
      primaryContainer: Color(0xFFDCFCE7),
      onPrimaryContainer: Color(0xFF14532D),
    ),
    AccentColorOption(
      id: 'burgundy_wine',
      name: 'Burgundy Wine',
      nameHi: 'बरगंडी वाइन',
      category: 'Deep',
      primary: Color(0xFF881337),
      primaryLight: Color(0xFFE11D48),
      primaryDark: Color(0xFF4C0519),
      primaryContainer: Color(0xFFFFE4E6),
      onPrimaryContainer: Color(0xFF881337),
    ),
    AccentColorOption(
      id: 'royal_plum',
      name: 'Royal Plum',
      nameHi: 'रॉयल प्लम',
      category: 'Deep',
      primary: Color(0xFF581C87),
      primaryLight: Color(0xFF9333EA),
      primaryDark: Color(0xFF3B0764),
      primaryContainer: Color(0xFFF3E8FF),
      onPrimaryContainer: Color(0xFF581C87),
    ),
    AccentColorOption(
      id: 'burnt_ember',
      name: 'Burnt Ember',
      nameHi: 'जला हुआ अंगारा',
      category: 'Deep',
      primary: Color(0xFF7C2D12),
      primaryLight: Color(0xFFEA580C),
      primaryDark: Color(0xFF431407),
      primaryContainer: Color(0xFFFFEDD5),
      onPrimaryContainer: Color(0xFF7C2D12),
    ),
    AccentColorOption(
      id: 'deep_ocean',
      name: 'Deep Ocean',
      nameHi: 'गहरा सागर',
      category: 'Deep',
      primary: Color(0xFF0C4A6E),
      primaryLight: Color(0xFF0284C7),
      primaryDark: Color(0xFF082F49),
      primaryContainer: Color(0xFFE0F2FE),
      onPrimaryContainer: Color(0xFF0C4A6E),
    ),
    AccentColorOption(
      id: 'charcoal_blue',
      name: 'Charcoal Blue',
      nameHi: 'चारकोल नीला',
      category: 'Deep',
      primary: Color(0xFF334155),
      primaryLight: Color(0xFF475569),
      primaryDark: Color(0xFF1E293B),
      primaryContainer: Color(0xFFF1F5F9),
      onPrimaryContainer: Color(0xFF0F172A),
    ),
    AccentColorOption(
      id: 'midnight_green',
      name: 'Midnight Green',
      nameHi: 'मिडनाइट ग्रीन',
      category: 'Deep',
      primary: Color(0xFF004D40),
      primaryLight: Color(0xFF00695C),
      primaryDark: Color(0xFF00251A),
      primaryContainer: Color(0xFFE0F2F1),
      onPrimaryContainer: Color(0xFF004D40),
    ),
    AccentColorOption(
      id: 'dark_magenta',
      name: 'Dark Magenta',
      nameHi: 'गहरा मैजेंटा',
      category: 'Deep',
      primary: Color(0xFF8B008B),
      primaryLight: Color(0xFFA020F0),
      primaryDark: Color(0xFF4B0082),
      primaryContainer: Color(0xFFF3E5F5),
      onPrimaryContainer: Color(0xFF4A148C),
    ),
    AccentColorOption(
      id: 'onyx',
      name: 'Onyx',
      nameHi: 'ओनिक्स',
      category: 'Deep',
      primary: Color(0xFF1F2937),
      primaryLight: Color(0xFF374151),
      primaryDark: Color(0xFF111827),
      primaryContainer: Color(0xFFF3F4F6),
      onPrimaryContainer: Color(0xFF111827),
    ),

    // -------------------------------------------------------------------------
    // EARTHY (Natural & Grounded)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'sage_green',
      name: 'Sage Green',
      nameHi: 'सेज हरा',
      category: 'Earthy',
      primary: Color(0xFF84A98C),
      primaryLight: Color(0xFFCAD2C5),
      primaryDark: Color(0xFF52796F),
      primaryContainer: Color(0xFFEFF7F3),
      onPrimaryContainer: Color(0xFF2F3E46),
    ),
    AccentColorOption(
      id: 'terra_cotta',
      name: 'Terra Cotta',
      nameHi: 'टेरा कोट्टा',
      category: 'Earthy',
      primary: Color(0xFFE07A5F),
      primaryLight: Color(0xFFF2CC8F),
      primaryDark: Color(0xFFD62828),
      primaryContainer: Color(0xFFFFF5F2),
      onPrimaryContainer: Color(0xFF3D405B),
    ),
    AccentColorOption(
      id: 'sandstone',
      name: 'Sandstone',
      nameHi: 'सैंडस्टोन',
      category: 'Earthy',
      primary: Color(0xFFD4A373),
      primaryLight: Color(0xFFE9C46A),
      primaryDark: Color(0xFFA1683A),
      primaryContainer: Color(0xFFFFFDF5),
      onPrimaryContainer: Color(0xFF5C3D2E),
    ),
    AccentColorOption(
      id: 'olive_drab',
      name: 'Olive Drab',
      nameHi: 'जैतून ड्रब',
      category: 'Earthy',
      primary: Color(0xFF606C38),
      primaryLight: Color(0xFFA3B18A),
      primaryDark: Color(0xFF283618),
      primaryContainer: Color(0xFFF7F9E8),
      onPrimaryContainer: Color(0xFF283618),
    ),
    AccentColorOption(
      id: 'mocha',
      name: 'Mocha',
      nameHi: 'मोचा',
      category: 'Earthy',
      primary: Color(0xFF8D6E63),
      primaryLight: Color(0xFFA1887F),
      primaryDark: Color(0xFF6D4C41),
      primaryContainer: Color(0xFFEFEBE9),
      onPrimaryContainer: Color(0xFF3E2723),
    ),
    AccentColorOption(
      id: 'taupe',
      name: 'Taupe',
      nameHi: 'टाउपे',
      category: 'Earthy',
      primary: Color(0xFFA8A29E),
      primaryLight: Color(0xFFD6D3D1),
      primaryDark: Color(0xFF78716C),
      primaryContainer: Color(0xFFF5F5F4),
      onPrimaryContainer: Color(0xFF292524),
    ),
    AccentColorOption(
      id: 'warm_grey',
      name: 'Warm Grey',
      nameHi: 'वार्म ग्रे',
      category: 'Earthy',
      primary: Color(0xFF78716C), // Stone 500
      primaryLight: Color(0xFFA8A29E),
      primaryDark: Color(0xFF57534E),
      primaryContainer: Color(0xFFFAFAF9),
      onPrimaryContainer: Color(0xFF1C1917),
    ),
    AccentColorOption(
      id: 'mushroom',
      name: 'Mushroom',
      nameHi: 'मशरूम',
      category: 'Earthy',
      primary: Color(0xFFA1887F),
      primaryLight: Color(0xFFD7CCC8),
      primaryDark: Color(0xFF8D6E63),
      primaryContainer: Color(0xFFEFEBE9),
      onPrimaryContainer: Color(0xFF3E2723),
    ),

    // -------------------------------------------------------------------------
    // MONOCHROME (Sleek & Minimal)
    // -------------------------------------------------------------------------
    AccentColorOption(
      id: 'slate_grey',
      name: 'Slate Grey',
      nameHi: 'स्लेट ग्रे',
      category: 'Monochrome',
      primary: Color(0xFF64748B),
      primaryLight: Color(0xFF94A3B8),
      primaryDark: Color(0xFF475569),
      primaryContainer: Color(0xFFF1F5F9),
      onPrimaryContainer: Color(0xFF0F172A),
    ),
    AccentColorOption(
      id: 'zinc_metal',
      name: 'Zinc Metal',
      nameHi: 'जिंक मेटल',
      category: 'Monochrome',
      primary: Color(0xFF71717A),
      primaryLight: Color(0xFFA1A1AA),
      primaryDark: Color(0xFF52525B),
      primaryContainer: Color(0xFFF4F4F5),
      onPrimaryContainer: Color(0xFF18181B),
    ),
    AccentColorOption(
      id: 'neutral_steel',
      name: 'Neutral Steel',
      nameHi: 'तटस्थ स्टील',
      category: 'Monochrome',
      primary: Color(0xFF737373),
      primaryLight: Color(0xFFA3A3A3),
      primaryDark: Color(0xFF525252),
      primaryContainer: Color(0xFFF5F5F5),
      onPrimaryContainer: Color(0xFF171717),
    ),
    AccentColorOption(
      id: 'blue_steel',
      name: 'Blue Steel',
      nameHi: 'ब्लू स्टील',
      category: 'Monochrome',
      primary: Color(0xFF607D8B),
      primaryLight: Color(0xFF90A4AE),
      primaryDark: Color(0xFF455A64),
      primaryContainer: Color(0xFFECEFF1),
      onPrimaryContainer: Color(0xFF263238),
    ),
    AccentColorOption(
      id: 'pure_black',
      name: 'Pure Black',
      nameHi: 'शुद्ध काला',
      category: 'Monochrome',
      primary: Color(0xFF262626), // Neutral 900
      primaryLight: Color(0xFF525252),
      primaryDark: Color(0xFF171717),
      primaryContainer: Color(0xFFF5F5F5),
      onPrimaryContainer: Color(0xFF0A0A0A),
    ),
    AccentColorOption(
      id: 'cool_grey',
      name: 'Cool Grey',
      nameHi: 'कूल ग्रे',
      category: 'Monochrome',
      primary: Color(0xFF9CA3AF), // Gray 400
      primaryLight: Color(0xFFD1D5DB),
      primaryDark: Color(0xFF6B7280),
      primaryContainer: Color(0xFFF3F4F6),
      onPrimaryContainer: Color(0xFF111827),
    ),
  ];

  static const Color secondaryColor = Color(0xFFE11D48);
  static const Color secondaryLightColor = Color(0xFFFB7185);
  static const Color secondaryDarkColor = Color(0xFF9F1239);
  static const Color secondaryContainerColor = Color(0xFFFFF1F2);
  static const Color onSecondaryContainerColor = Color(0xFF881337);

  static const Color accentColor = Color(0xFFF59E0B);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorColor = Color(0xFFEF4444);

  static const Color lightBackgroundColor = Color(0xFFF8FAFC);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color lightOutlineColor = Color(0xFFE2E8F0);
  static const Color lightOutlineVariantColor = Color(0xFFF1F5F9);
  static const Color lightOnSurfaceColor = Color(0xFF0F172A);
  static const Color lightOnSurfaceVariantColor = Color(0xFF64748B);

  static const Color darkBackgroundColor = Color(0xFF0F172A);
  static const Color darkSurfaceColor = Color(0xFF1E293B);
  static const Color darkCardColor = Color(0xFF1E293B);
  static const Color darkOutlineColor = Color(0xFF334155);
  static const Color darkOutlineVariantColor = Color(0xFF475569);
  static const Color darkOnSurfaceColor = Color(0xFFF8FAFC);
  static const Color darkOnSurfaceVariantColor = Color(0xFF94A3B8);

  static AccentColorOption getColorById(String id) {
    return accentColors.firstWhere(
      (c) => c.id == id,
      orElse: () => accentColors.first,
    );
  }
  
  static Map<String, List<AccentColorOption>> get categorizedColors {
    final map = <String, List<AccentColorOption>>{};
    for (var color in accentColors) {
      if (!map.containsKey(color.category)) {
        map[color.category] = [];
      }
      map[color.category]!.add(color);
    }
    return map;
  }
}

class AccentColorOption {
  final String id;
  final String name;
  final String nameHi;
  final String category;
  final Color primary;
  final Color primaryLight;
  final Color primaryDark;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  const AccentColorOption({
    required this.id,
    required this.name,
    required this.nameHi,
    required this.category,
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.primaryContainer,
    required this.onPrimaryContainer,
  });

  String getLocalizedName(String languageCode) {
    return languageCode == 'hi' ? nameHi : name;
  }
}
